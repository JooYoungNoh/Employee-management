//
//  TinfoVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/20.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class TinfoVM {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //사진 셀
    var pictureList: [UIImage] = []              //최종 사진 리스트
    var newPictureList: [UIImage] = []           //추가 사진 리스트
    var copyImageList: [String] = []             //복사 이름 리스트(테이블)
    var imageNameList: [String] = []             //사진 이름 리스트
    var pictureDeleteNumberList: [Int] = []      //사진 삭제 리스트
    
    //텍스트 뷰
    var titleMemo: String = ""                      //제목
    var textMemo: String = ""                       //내용
    
    //회사 삭제시 작성 금지 (회사 삭제 했는데 다른 사람이 작성 화면에 있을 경우 작성 금지을 위한 객체)
    var companyDelete: String = ""
    
    
    //MARK: 컬렉션 뷰 메소드
    //셀 정보
    func cellInfo(collectionView: UICollectionView, indexPath: IndexPath, titleOnTable: String, companyName: String) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransitionInfoCell.identifier, for: indexPath) as? TransitionInfoCell else { return UICollectionViewCell() }
        if indexPath.row < self.copyImageList.count{
            self.downloadimage(imageView: cell.imageView, titleOnTable: titleOnTable, companyName: companyName, indexPath: indexPath)
        } else {
            cell.imageView.image = self.newPictureList[indexPath.row - self.copyImageList.count]
        }
        
        if self.pictureDeleteNumberList.contains(indexPath.row) == true {
            cell.checkImageView.isHidden = false
        } else {
            cell.checkImageView.isHidden = true
        }
        return cell
    }
    
    //셀 선택
    func selectCell(collectionView: UICollectionView, indexPath: IndexPath){
        let cell  = collectionView.cellForItem(at: indexPath) as! TransitionInfoCell
        
        if cell.checkImageView.isHidden == true {
            cell.checkImageView.isHidden = false
            self.pictureDeleteNumberList.append(indexPath.row)
        } else {
            cell.checkImageView.isHidden = true
            if let index = self.pictureDeleteNumberList.firstIndex(of: indexPath.row){
                self.pictureDeleteNumberList.remove(at: index)
            }
        }
    }
    
    //MARK: 텍스트 뷰 메소드
    //텍스트 뷰
    func changeMemo(textView: UITextView, countLabel: UILabel){
        let contents = textView.text as NSString
        var textCount = -1
        countLabel.text = "\(String(describing: contents.length))"
        let length = contents.length > 19 ? 19 : contents.length
        
        if let rangeText = textView.text.range(of: "\n"){
            textCount = textView.text.distance(from: textView.text.startIndex, to: rangeText.lowerBound)
            self.titleMemo = contents.substring(with: NSRange(location: 0, length: textCount))
        } else {
            textCount = -1
            self.titleMemo = contents.substring(with: NSRange(location: 0, length: length))
        }
        
        self.textMemo = contents as String
        
        if contents.length == 0{
            countLabel.text = "0"
        }
        
    }
    
    func endMemo(textView: UITextView, countLabel: UILabel){
        if textView.text == "" || textView.text == "첫줄은 제목입니다." {
            textView.text = "첫줄은 제목입니다."
            textView.textColor = .systemGray
            countLabel.text = "0"
        }
    }
    
    func startMemo(textView: UITextView, countLabel: UILabel){
        if textView.text == "" || textView.text == "첫줄은 제목입니다." {
            textView.text = ""
            textView.textColor = .black
            countLabel.text = "0"
        }
    }
    
    //MARK: 액션 메소드
    //사진 삭제
    func deletePicture(view: UIViewController, collectionView: UICollectionView){
        if self.pictureDeleteNumberList.isEmpty == true {
            let alert = UIAlertController(title: nil, message: "사진을 선택해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            view.present(alert, animated: true)
        } else {
            var sortArry = self.pictureDeleteNumberList.sorted(by: {$0 > $1})
            
            for i in sortArry{
                collectionView.deleteItems(at: [IndexPath.init(row: i, section: 0)])
                if i >= self.copyImageList.count{
                    self.newPictureList.remove(at: i)
                } else {
                    self.copyImageList.remove(at: i)
                }
            }
            self.pictureDeleteNumberList.removeAll()
            sortArry.removeAll()
        }
    }
    
    //메모 저장
    func doSave(uv: UIViewController, collectionView: UICollectionView, companyName: String, naviTitle: String, titleOnTable: String, textOnTable: String,imageListOnTable: [String], checkTitle: [String], writeTV: UITextView, countLabel: UILabel){
        
        self.companyDelete = ""
        self.db.collection("shop").whereField("company", isEqualTo: "\(companyName)").getDocuments { snapShot, error in
            for doc in snapShot!.documents{
                self.companyDelete = doc.documentID
            }
            print(self.companyDelete)
            if self.companyDelete == "" {
                let alert = UIAlertController(title: "회사가 존재하지않습니다.", message: "확인해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                    uv.dismiss(animated: true)
                })
                uv.present(alert, animated: true)
            } else {
                if self.appDelegate.jobInfo == "2"{
                    let alert = UIAlertController(title: nil, message: "직원 이상의 직책만 사용가능합니다", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    uv.present(alert, animated: true)
                } else {
                    if self.titleMemo == "" || self.titleMemo == "첫줄은 제목입니다."{
                        let alert = UIAlertController(title: "내용이 없습니다", message: "다시 입력해주세요", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        uv.present(alert, animated: true)
                    } else {
                        //사진 한곳에 모으기
                        self.pictureList.removeAll()
                        for i in 0..<self.copyImageList.count{
                            let indexPath = IndexPath(row: i, section: 0)
                            let cell  = collectionView.cellForItem(at: indexPath) as! TransitionInfoCell
                            self.pictureList.append(cell.imageView.image!)
                        }
                        for y in self.newPictureList{
                            self.pictureList.append(y)
                        }
                        
                        
                        //이미지 이름 리스트 만들기
                        self.imageNameList.removeAll()
                        for i in 0..<(self.pictureList.count){
                            self.imageNameList.append("\(self.titleMemo)_\(i)")
                        }
                        //시간 정보
                        let date = Date().timeIntervalSince1970
                        
                        if titleOnTable == self.titleMemo {
                            if self.copyImageList == imageListOnTable && self.newPictureList.count == 0 {
                                if textOnTable == self.textMemo {   //변경 x
                                    let alert = UIAlertController(title: "변경 사항이 없습니다", message: nil, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                                    uv.present(alert, animated: true)
                                } else {
                                    let alert = UIAlertController(title: "메모가 변경되었습니다", message: "저장하시겠습니까", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                                        
                                        //fireStore에서 배열 값 변경
                                        self.db.collection("shop").document("\(companyName)").collection("\(naviTitle == "레시피 정보" ? "recipe" : "transition")").document("\(titleOnTable)").updateData([
                                            "count" : countLabel.text,
                                            "date" : date,
                                            "text" : self.textMemo
                                        ])
                                        
                                        uv.navigationController?.popViewController(animated: true)
                                    })
                                    
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                    
                                    uv.present(alert, animated: true)
                                }
                            } else {
                                if textOnTable == self.textMemo {               //사진만 변경
                                    let alert = UIAlertController(title: "사진이 변경되었습니다", message: "저장하시겠습니까", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                                        //fireStore에서 배열 값 변경
                                        self.db.collection("shop").document("\(companyName)").collection("\(naviTitle == "레시피 정보" ? "recipe" : "transition")").document("\(titleOnTable)").updateData([
                                            "date" : date,
                                            "imageList" : self.imageNameList
                                        ])
                                        
                                        //기존 사진 삭제
                                        self.deleteImage(titleOnTable: titleOnTable, companyName: companyName, imageListOnTable: imageListOnTable)
                                        //새로운 사진 업로드
                                        self.uploadimage(title: self.titleMemo, companyName: companyName)
                                        
                                        uv.navigationController?.popViewController(animated: true)
                                    })
                                    
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                    
                                    uv.present(alert, animated: true)
                                } else {                    //둘다 변경
                                    let alert = UIAlertController(title: "모두 변경되었습니다", message: "저장하시겠습니까", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                                        //fireStore에서 배열 값 변경
                                        self.db.collection("shop").document("\(companyName)").collection("\(naviTitle == "레시피 정보" ? "recipe" : "transition")").document("\(titleOnTable)").updateData([
                                            "count" : countLabel.text,
                                            "date" : date,
                                            "text" : self.textMemo,
                                            "imageList" : self.imageNameList
                                        ])
                                        
                                        //기존 사진 삭제
                                        self.deleteImage(titleOnTable: titleOnTable, companyName: companyName, imageListOnTable: imageListOnTable)
                                        
                                        //새로운 사진 업로드
                                        self.uploadimage(title: self.titleMemo, companyName: companyName)
                                        
                                        uv.navigationController?.popViewController(animated: true)
                                    })
                                    
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                    
                                    uv.present(alert, animated: true)
                                }
                                
                            }
                        } else {                    //제목이 다를 때
                            if self.copyImageList == imageListOnTable && self.newPictureList.count == 0{     //글만 변경
                                if checkTitle.firstIndex(of: self.titleMemo) != nil {
                                    let alert = UIAlertController(title: "이미 있는 제목입니다", message: "다시 작성해주세요", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                                    uv.present(alert, animated: true)
                                } else {
                                    let alert = UIAlertController(title: "메모가 변경되었습니다", message: "저장하시겠습니까", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                                        //기존 정보 삭제
                                        self.db.collection("shop").document("\(companyName)").collection("\(naviTitle == "레시피 정보" ? "recipe" : "transition")").document("\(titleOnTable)").delete()
                                        
                                        //새로운 정보 생성
                                        self.db.collection("shop").document("\(companyName)").collection("\(naviTitle == "레시피 정보" ? "recipe" : "transition")").document("\(self.titleMemo)").setData([
                                            "text" : "\(writeTV.text!)",
                                            "count" : "\(countLabel.text!)",
                                            "date" : date,
                                            "title" : "\(self.titleMemo)",
                                            "imageList" : self.imageNameList
                                        ])
                                        
                                        //기존 사진 삭제
                                        self.deleteImage(titleOnTable: titleOnTable, companyName: companyName, imageListOnTable: imageListOnTable)
                                        //새로운 사진 업로드
                                        self.uploadimage(title: self.titleMemo, companyName: companyName)
                                        
                                        uv.navigationController?.popViewController(animated: true)
                                    })
                                    
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                    
                                    uv.present(alert, animated: true)
                                }
                                
                            } else {                //둘 다 변경
                                if checkTitle.firstIndex(of: self.titleMemo) != nil {
                                    let alert = UIAlertController(title: "이미 있는 제목입니다", message: "다시 작성해주세요", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                                    uv.present(alert, animated: true)
                                } else {
                                    let alert = UIAlertController(title: "모두 변경되었습니다", message: "저장하시겠습니까", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                                        //기존 정보 삭제
                                        self.db.collection("shop").document("\(companyName)").collection("\(naviTitle == "레시피 정보" ? "recipe" : "transition")").document("\(titleOnTable)").delete()
                                        
                                        //새로운 정보 생성
                                        self.db.collection("shop").document("\(companyName)").collection("\(naviTitle == "레시피 정보" ? "recipe" : "transition")").document("\(self.titleMemo)").setData([
                                            "text" : "\(writeTV.text!)",
                                            "count" : "\(countLabel.text!)",
                                            "date" : date,
                                            "title" : "\(self.titleMemo)",
                                            "imageList" : self.imageNameList
                                        ])
                                        
                                        //기존 사진 삭제
                                        self.deleteImage(titleOnTable: titleOnTable, companyName: companyName, imageListOnTable: imageListOnTable)
                                        //새로운 사진 업로드
                                        self.uploadimage(title: self.titleMemo, companyName: companyName)
                                        
                                        uv.navigationController?.popViewController(animated: true)
                                    })
                                    
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                    
                                    uv.present(alert, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //메모 저장 메소드
    func changeMemo(){
        
    }
    
    //이미지 다운로드
    func downloadimage(imageView: UIImageView, titleOnTable: String, companyName: String, indexPath: IndexPath){
        if self.copyImageList.count != 0{
            storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/\(companyName)/\(titleOnTable)/\(self.copyImageList[indexPath.row])").downloadURL { (url, error) in
                if error == nil && url != nil {
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                        
                    imageView.image = image!
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    //이미지 업로드(in FireStorage)
    func uploadimage(title: String, companyName: String){
        if pictureList.isEmpty == false {
            for i in 0..<pictureList.count{
                var data = Data()
                data = pictureList[i].jpegData(compressionQuality: 0.8)!
                
                let filePath = "\(companyName)/\(self.titleMemo)/\(self.titleMemo)_\(i)"       //글 제목_번호
                let metaData = StorageMetadata()
                metaData.contentType = "image/png"
                
                storage.reference().child(filePath).putData(data, metadata: metaData) { (metaData,error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("성공")
                    }
                }
            }
        }
    }
    
    //이미지 삭제
    func deleteImage(titleOnTable: String, companyName: String, imageListOnTable: [String]) {
        for i in imageListOnTable {
            storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/\(companyName)/\(titleOnTable)/\(i)").delete { (error) in
                if let error = error{
                    print(error.localizedDescription)
                } else {
                    print("이미지 삭제 성공")
                }
            }
        }
    }
    
}
