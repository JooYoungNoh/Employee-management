//
//  ChattingInterlocutorVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/09/26.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ChattingInterlocutorVM {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var userName: String = ""
    
    //MARK: 액션 메소드
    
    //이미지 다운
    func myDownloadimage(imgView: UIImageView, phone: String){
        storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/userprofile/\(phone)").downloadURL { (url, error) in
            if error == nil && url != nil {
                let data = NSData(contentsOf: url!)
                let dbImage = UIImage(data: data! as Data)
                
                imgView.image = dbImage
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //전화변호로 이미지 찾기
    func findProfileImage(imgView: UIImageView, phone: String, userImageList: [roomImageSave]){
        if let index = userImageList.firstIndex(where: {$0.userPhone == phone}){
            imgView.image = userImageList[index].userImage
        } else {
            imgView.image = UIImage(named: "account")
        }
    }
    
    //MARK: 테이블 뷰 메소드
    func cellInfoTable(tableView: UITableView, indexPath: IndexPath, phoneListOntable: [String], userImageList: [roomImageSave]) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingInterlocutorCell", for: indexPath) as? ChattingInterlocutorCell else { return UITableViewCell() }
        
        if phoneListOntable[indexPath.row] == self.appDelegate.phoneInfo! {
            cell.nameLabel.text = self.appDelegate.nameInfo!
            
            if self.appDelegate.profileState == false {
                cell.userImageView.image = UIImage(named: "account")
            } else {
                DispatchQueue.main.async {
                    self.myDownloadimage(imgView: cell.userImageView, phone: self.appDelegate.phoneInfo!)
                }
            }
        } else {
            //이름
            self.db.collection("users").whereField("phone", isEqualTo: "\(phoneListOntable[indexPath.row])").getDocuments { snapshot, error in
                if error == nil {
                    for doc in snapshot!.documents{
                        self.userName = doc.data()["name"] as! String
                    }
                    cell.nameLabel.text = self.userName
                } else {
                    print(error!.localizedDescription)
                }
            }
            
            //프로필 사진
            DispatchQueue.main.async {
                self.findProfileImage(imgView: cell.userImageView, phone: phoneListOntable[indexPath.row], userImageList: userImageList)
            }
        }
        
        return cell
    }
}
