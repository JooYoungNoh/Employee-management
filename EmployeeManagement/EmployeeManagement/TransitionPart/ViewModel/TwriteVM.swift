//
//  TwriteVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/20.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

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
    
    //MARK: 컬렉션 뷰 메소드
    //셀 정보
    func cellInfo(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransitionWriteCell.identifier, for: indexPath) as? TransitionWriteCell else { return UICollectionViewCell() }
        
        cell.imageView.image = self.pictureList[indexPath.row]
        cell.checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        cell.checkImageView.isHidden = true
        
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
        countLabel.text = "\(String(describing: contents.length))"
        let length = contents.length > 19 ? 19 : contents.length
        self.titleMemo = contents.substring(with: NSRange(location: 0, length: length))
        
        if contents.length != 0{
            if contents == "첫줄은 제목입니다."{
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
                self.uploadimage(title: self.titleMemo)
                
                uv.dismiss(animated: true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            uv.present(alert, animated: true)
        }
    }
    
    //firebase에 메모 저장
    func uploadMemo(companyName: String, naviTitle: String, writeTV: UITextView, countLabel: UILabel){
        let kindSelect = naviTitle == "레시피 작성" ? "recipe" : "transition"
        let date = Date().timeIntervalSince1970
        for i in 0..<(self.pictureList.count){
            self.imageNameList.append("\(self.titleMemo)_\(i)")
        }
        
        self.db.collection("shop").document("\(companyName)").collection("\(kindSelect)").addDocument(data: [
            "text" : "\(writeTV.text!)",
            "count" : "\(countLabel.text!)",
            "date" : date,
            "title" : "\(self.titleMemo)",
            "imageList" : self.imageNameList
        ])
    }
    
    //이미지 업로드(in FireStorage)
    func uploadimage(title: String){
        if pictureList.isEmpty == false {
            for i in 0..<pictureList.count{
                var data = Data()
                data = pictureList[i].jpegData(compressionQuality: 0.8)!
                
                let filePath = "\(title)/\(title)_\(i)"       //글 제목_번호
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
        } else {
            
        }
    }
}
