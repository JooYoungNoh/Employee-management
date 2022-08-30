//
//  ChattingRoomVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/26.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ChattingRoomVM {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var listner: ListenerRegistration?              //리스너 삭제
    
    var activationStatus: Bool = false              //활성화 여부
    
    
    //MARK: 액션 메소드
    //채팅 리스트 불러오기
    func bringChattingList(dbOnTable: String, activationOnTable: Bool, completion: @escaping([ChattingModel]) -> () ){
        if activationOnTable == false && self.activationStatus == false {
            
        } else {
            
        }
        
        /*self.listner = query.order(by: "date", descending: true).addSnapshotListener { (snapShot, error) in
            if error == nil && snapShot != nil{
                self.chattingList.removeAll()
                self.searchChattingList.removeAll()
                
                for doc in snapShot!.documents{
                    self.chattingList.append(ChattingModel.init(activation: doc.data()["activation"] as! Bool, date: doc.data()["date"] as! TimeInterval, memberCount: doc.data()["memberCount"] as! String, newCount: doc.data()["newCount"] as! String, newMessage: doc.data()["newMessage"] as! String, roomTitle: doc.data()["roomTitle"] as! String, phoneList: doc.data()["phoneList"] as! [String], presentUser: doc.data()["presentUser"] as! [String], dbID: doc.documentID))
                }
                
                for i in self.chattingList {
                    for y in i.phoneList {
                        self.profileDownloadimage(phone: y)
                    }
                }
                
                completion(self.chattingList)
            } else {
                print(error!.localizedDescription)
            }
        }*/
    }
    
    //현재 인원에서 이름 삭제
    func deletePresentUser(presentUserOnTable: [String], dbIDOnTable: String){
        var newpresentUser = presentUserOnTable
        if let index = newpresentUser.firstIndex(of: self.appDelegate.phoneInfo!){
            print(index)
            newpresentUser.remove(at: index)
            self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                "presentUser" : newpresentUser
            ])
        }
    }
    
    //MARK: 테이블 뷰 메소드
    
}
