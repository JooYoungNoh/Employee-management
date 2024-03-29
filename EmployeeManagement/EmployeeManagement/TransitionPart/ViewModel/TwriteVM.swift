//
//  TwriteVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/20.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class TwriteVM{
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //사진 셀
    var pictureList: [UIImage] = []                 //사진 리스트
    var pictureDeleteNumberList: [Int] = []         //사진 삭제 리스트
    var imageNameList: [String] = []                //사진 이름 리스트
    
    //텍스트 뷰
    var titleMemo: String = ""                      //제목
    
    //회사 삭제시 작성 금지 (회사 삭제 했는데 다른 사람이 작성 화면에 있을 경우 작성 금지을 위한 객체)
    var companyDelete: String = ""
    
    
    //MARK: 컬렉션 뷰 메소드
    //셀 정보
    func cellInfo(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransitionWriteCell.identifier, for: indexPath) as? TransitionWriteCell else { return UICollectionViewCell() }
        
        if self.pictureDeleteNumberList.contains(indexPath.row) == true {
            cell.checkImageView.isHidden = false
        } else {
            cell.checkImageView.isHidden = true
        }
        cell.imageView.image = self.pictureList[indexPath.row]
        
        return cell
    }
    
    //셀 선택
    func selectCell(collectionView: UICollectionView, indexPath: IndexPath){
        let cell  = collectionView.cellForItem(at: indexPath) as! TransitionWriteCell
        
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
    func changeMemo(textView: UITextView, countLabel: UILabel, saveButton: UIButton){
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
        
        if contents.length != 0 {
            if contents == "첫줄은 제목입니다." || textCount == 0{
                saveButton.isHidden = true
            } else {
                saveButton.isHidden = false
            }
        } else {
            saveButton.isHidden = true
            countLabel.text = "0"
        }
    }
    
    func endMemo(textView: UITextView, countLabel: UILabel, saveButton: UIButton){
        if textView.text == "" || textView.text == "첫줄은 제목입니다." {
            textView.text = "첫줄은 제목입니다."
            textView.textColor = .systemGray
            saveButton.isHidden = true
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
                self.pictureList.remove(at: i)
            }
            self.pictureDeleteNumberList.removeAll()
            sortArry.removeAll()
        }
    }
    
    //메모 저장 메소드
    func saveMemoFB(uv: UIViewController, checkTitle: [String], companyName: String, naviTitle: String, writeTV: UITextView, countLabel: UILabel){
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
                if checkTitle.firstIndex(of: self.titleMemo) != nil {
                    let alert = UIAlertController(title: "이미 있는 제목입니다", message: "다시 작성해주세요", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    uv.present(alert, animated: true)
                    
                } else if self.pictureList.isEmpty == true {
                    let alert = UIAlertController(title: "사진이 없습니다", message: "저장하시겠습니까?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                        //메모 저장
                        self.uploadMemo(companyName: companyName, naviTitle: naviTitle, writeTV: writeTV, countLabel: countLabel)
                        uv.dismiss(animated: true)
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    uv.present(alert, animated: true)
                    
                } else {
                    let alert = UIAlertController(title: nil, message: "저장하시겠습니까?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                        //메모 저장
                        self.uploadMemo(companyName: companyName, naviTitle: naviTitle, writeTV: writeTV, countLabel: countLabel)
                        
                        //이미지 저장
                        self.uploadimage(title: self.titleMemo, companyName: companyName)
                        
                        uv.dismiss(animated: true)
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    uv.present(alert, animated: true)
                }
            }
        }
    }
    
    //firebase에 메모 저장
    func uploadMemo(companyName: String, naviTitle: String, writeTV: UITextView, countLabel: UILabel){
        let kindSelect = naviTitle == "레시피 작성" ? "recipe" : "transition"
        let date = Date().timeIntervalSince1970
        for i in 0..<(self.pictureList.count){
            self.imageNameList.append("\(self.titleMemo)_\(i)")
        }
        
        self.db.collection("shop").document("\(companyName)").collection("\(kindSelect)").document("\(self.titleMemo)").setData([
            "text" : "\(writeTV.text!)",
            "count" : "\(countLabel.text!)",
            "date" : date,
            "title" : "\(self.titleMemo)",
            "imageList" : self.imageNameList
        ])
    }
    
    //이미지 업로드(in FireStorage)
    func uploadimage(title: String, companyName: String){
        if pictureList.isEmpty == false {
            for i in 0..<pictureList.count{
                var data = Data()
                data = pictureList[i].jpegData(compressionQuality: 0.8)!
                
                let filePath = "\(companyName)/\(title)/\(title)_\(i)"       //글 제목_번호
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
}
