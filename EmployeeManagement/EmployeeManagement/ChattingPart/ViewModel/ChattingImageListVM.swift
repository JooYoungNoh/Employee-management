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
    
    var userName: String = ""           //사진 보낸 사람 이름 저장 변수
    
    //MARK: 테이블 뷰 메소드
    func cellInfo(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingImageListCell.identifier, for: indexPath) as? ChattingImageListCell else { return UICollectionViewCell() }
    
        cell.imageView.image = self.appDelegate.imageList[indexPath.row].image
        return cell
    }
    
    //테이블 뷰 섹션에 나타낼 로우 갯수
    func numberOfRowsInSection() -> Int {
        return self.appDelegate.imageList.count
    }
    
    //셀 선택
    func selectCell(collectionView: UICollectionView, indexPath: IndexPath, uv: UIViewController){
        guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "ChattingImageInfoVC") as? ChattingImageInfoVC else { return }
        //사진 보낸 사람 이름
        let splitName = self.appDelegate.imageList[indexPath.row].title.split(separator: "_")
        self.db.collection("users").whereField("phone", isEqualTo: "\(splitName[0])").getDocuments { snapshot, error in
            if error == nil {
                for doc in snapshot!.documents{
                    self.userName = doc.data()["name"] as! String
                }
                //시간 정재
                let date = Date(timeIntervalSince1970: self.appDelegate.imageList[indexPath.row].date)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let fixDate = "\(formatter.string(from: date))"
                
                nv.nameOnTable = self.userName
                nv.dateOnTable = fixDate
                nv.imageOnTable = self.appDelegate.imageList[indexPath.row].image
                uv.navigationController?.pushViewController(nv, animated: true)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}
