//
//  TinfoVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/20.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class TinfoVM {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //사진 셀
    var pictureList: [UIImage] = []                 //사진 리스트
    var pictureDeleteNumberList: [Int] = []         //사진 삭제 리스트
    
    //텍스트 뷰
    var titleMemo: String = ""                      //제목
    
    //MARK: 컬렉션 뷰 메소드
    //셀 정보
    func cellInfo(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransitionInfoCell.identifier, for: indexPath) as? TransitionInfoCell else { return UICollectionViewCell() }
        
        cell.imageView.image = self.pictureList[indexPath.row]
        cell.checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        cell.checkImageView.isHidden = true
        
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
        countLabel.text = "\(String(describing: contents.length))"
        let length = contents.length > 19 ? 19 : contents.length
        self.titleMemo = contents.substring(with: NSRange(location: 0, length: length))
        
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
    //이미지 다운로드
    func downloadimage(imageCount: String, titleOnTable: String){
        if imageCount != "0"{
            for i in 0..<Int(imageCount)!{
                storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/\(titleOnTable)_\(i)").downloadURL { (url, error) in
                    if error == nil && url != nil {
                        let data = NSData(contentsOf: url!)
                        let image = UIImage(data: data! as Data)
                        
                        self.pictureList.append(image!)
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    //이미지 업로드(in FireStorage)
    func uploadimage(title: String){
        if pictureList.isEmpty == false {
            for i in 0..<pictureList.count{
                var data = Data()
                data = pictureList[i].jpegData(compressionQuality: 0.8)!
                
                let filePath = "\(title)_\(i)"       //글 제목_번호
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
