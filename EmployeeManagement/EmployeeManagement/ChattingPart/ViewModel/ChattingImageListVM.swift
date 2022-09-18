//
//  ChattingImageListVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/09/19.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ChattingImageListVM {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK: 액션 메소드
    
    
    //MARK: 테이블 뷰 메소드
    func cellInfo(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingImageListCell.identifier, for: indexPath) as? ChattingImageListCell else { return UICollectionViewCell() }
    
        cell.imageView.image = self.appDelegate.imageList[indexPath.row].userImage
        return cell
    }
    
    //테이블 뷰 섹션에 나타낼 로우 갯수
    func numberOfRowsInSection() -> Int {
        return self.appDelegate.imageList.count
    }
}
