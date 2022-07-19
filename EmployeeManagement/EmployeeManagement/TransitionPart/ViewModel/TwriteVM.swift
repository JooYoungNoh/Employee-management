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
    var pictureList: [UIImage] = [UIImage(named: "recipe")!, UIImage(named: "recipe")!]                 //사진 리스트
    var pictureDeleteNumberList: [Int] = []         //사진 삭제 리스트
    
    //MARK: 컬렉션 뷰 메소드
    //셀 정보
    func cellInfo(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransitionWriteCell.identifier, for: indexPath) as? TransitionWriteCell else { return UICollectionViewCell() }
        
        cell.imageView.image = self.pictureList[indexPath.row]
        cell.checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        
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
        print(self.pictureDeleteNumberList)
    }
    //MARK: 액션 메소드
    //사진 삭제
    func deletePicture(){
        
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
