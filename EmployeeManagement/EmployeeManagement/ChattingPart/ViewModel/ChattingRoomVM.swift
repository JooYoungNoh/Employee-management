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
    var imgCheck: Bool = false                      //이미지 유무
    
    var chatList: [ChattingRoomModel] = []
    
    //firebase 저장 변수(활성화 했을 떄 상대방에게 방 생성)
    var dbPhone: [String] = []
    var dbcheck: String = ""
    var dbName: String = ""
    var dbRoom: String = ""
    
    //인원들 아이디 저장 변수
    var dbResultID: String = ""
    
    //내가 방에서 나갈떄 있는 현재 인원
    var newpresentUser: [String] = []
    
    //내가 메시지 보낼때 있는 현재 인원
    var chatPresentUser: [String] = []
    
    
    //MARK: 액션 메소드
    //
    
    //채팅 리스트 불러오기
    func bringChattingList(dbOnTable: String, activationOnTable: Bool, completion: @escaping([ChattingModel]) -> () ){
        if activationOnTable == false && self.activationStatus == false {
            
        } else {
            self.activationStatus = true
            self.listner = self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").collection("chat").order(by: "date", descending: true).addSnapshotListener({ snapshot, error in
                if error == nil && snapshot != nil{
                    
                } else {
                    print(error!.localizedDescription)
                }
            })
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
    func deletePresentUser(dbIDOnTable: String, phoneListOnTable: [String], activationOnTable: Bool){
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").getDocument { snapshot2, error2 in
            if error2 == nil {
                self.newpresentUser = (snapshot2!.data()!["presentUser"] as! [String])
                
                if let index = self.newpresentUser.firstIndex(of: self.appDelegate.phoneInfo!){
                    self.newpresentUser.remove(at: index)
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                        "presentUser" : self.newpresentUser
                    ])
                    if self.activationStatus == true || activationOnTable == true {
                        for i in phoneListOnTable {
                            self.dbResultID = ""
                            self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                                if error == nil {
                                    for doc in snapshot!.documents{
                                        self.dbResultID = doc.documentID
                                    }
                                    self.db.collection("users").document("\(self.dbResultID)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                                        "presentUser" : self.newpresentUser
                                    ])
                                } else {
                                    print(error!.localizedDescription)
                                }
                            }
                        }
                    }
                }
            } else {
                print(error2!.localizedDescription)
            }
        }
    }
    
    //보내기 버튼 누를 때
    func doSendButton(activationOnTable: Bool, phoneListOnTable: [String], roomTitleOnTable: String, dbIDOnTable: String, writeTV: UITextView){
        let date = Date().timeIntervalSince1970
        
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").getDocument { snapshot3, error3 in
            if error3 == nil {
                self.chatPresentUser = (snapshot3!.data()!["presentUser"] as! [String])
                
                //비 활성화 상태 일때
                if self.activationStatus == false && activationOnTable == false {
                    self.activationStatus = true
                    //내 채팅 리스트 정보 업데이트
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                        "date" : date,
                        "newMessage" : "\(writeTV.text ?? "")",
                        "activation" : true
                    ])
                    
                    //내 채팅방 채팅 추가
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                        "checkRead" : true,
                        "imgCheck" : self.imgCheck,
                        "date" : date,
                        "sender" : "\(self.appDelegate.phoneInfo!)",
                        "message" : "\(writeTV.text ?? "")",
                        "readList" : ["\(self.appDelegate.phoneInfo!)"]
                    ])
                    
                    //다른 방 사람들에게 처음 메시지 보내기
                    for i in phoneListOnTable {
                        self.dbPhone.removeAll()
                        self.dbcheck = ""
                        self.dbName = ""
                        self.dbRoom = roomTitleOnTable
                        self.dbPhone = phoneListOnTable
                        var realRoomTitle = ""
                        if let index = self.dbPhone.firstIndex(of: i){
                            self.dbPhone.remove(at: index)
                            self.dbPhone.append(self.appDelegate.phoneInfo!)
                        }
                       
                        self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                            if error == nil {
                                for doc in snapshot!.documents{
                                    self.dbcheck = doc.documentID
                                    self.dbName = doc.data()["name"] as! String
                                }
                                //방 생성
                                if self.dbcheck != "" {
                                    if let range: Range<String.Index> = self.dbRoom.range(of: "\(self.dbName)") {
                                        self.dbRoom.removeSubrange(range)
                                    }
                                    
                                    if self.dbPhone.count == 1 {
                                        self.dbRoom = ""
                                        realRoomTitle = "\(self.appDelegate.nameInfo!)"
                                    } else {
                                        if self.dbRoom[self.dbRoom.startIndex] == "," {
                                            self.dbRoom.removeFirst()
                                        } else if self.dbRoom[self.dbRoom.index(before: self.dbRoom.endIndex)] == ","{
                                            self.dbRoom.removeLast()
                                        }
                                        realRoomTitle = self.dbRoom + ", \(self.appDelegate.nameInfo!)"
                                    }

                                    self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").setData([
                                        "date" : date,
                                        "roomTitle" : realRoomTitle,
                                        "phoneList" : self.dbPhone,
                                        "memberCount" : "\(self.dbPhone.count + 1)",
                                        "newMessage" : "\(writeTV.text ?? "")",
                                        "newCount" : "1",
                                        "activation" : true,
                                        "presentUser" : self.chatPresentUser
                                    ])
                                    //메시지 보내기
                                    self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                                        "checkRead" : false,
                                        "imgCheck" : self.imgCheck,
                                        "date" : date,
                                        "sender" : "\(self.appDelegate.phoneInfo!)",
                                        "message" : "\(writeTV.text ?? "")",
                                        "readList" : ["\(self.appDelegate.phoneInfo!)"]
                                    ])
                                }
                            } else {
                                print(error!.localizedDescription)
                            }
                        }
                    }
                } else {        //활성화 상태
                    //내 채팅 리스트 정보 업데이트
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                        "date" : date,
                        "newMessage" : "\(writeTV.text ?? "")",
                    ])
                    
                    //내 채팅방 채팅 추가
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                        "checkRead" : true,
                        "imgCheck" : self.imgCheck,
                        "date" : date,
                        "sender" : "\(self.appDelegate.phoneInfo!)",
                        "message" : "\(writeTV.text ?? "")",
                        "readList" : self.chatPresentUser
                    ])
                    
                    for i in phoneListOnTable {
                        self.dbPhone.removeAll()
                        self.dbcheck = ""
                        self.dbPhone = phoneListOnTable
                        if let index = self.dbPhone.firstIndex(of: i){
                            self.dbPhone.remove(at: index)
                            self.dbPhone.append(self.appDelegate.phoneInfo!)
                        }
                
                        self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                            if error == nil {
                                for doc in snapshot!.documents{
                                    self.dbcheck = doc.documentID
                                }
                                //다른 사람 방 업데이트
                                if self.dbcheck != "" {
                                    self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").getDocument { snapshot2, error2 in
                                        if error2 == nil {
                                            print(Int(snapshot2!.data()!["newCount"] as! String)!)
                                            self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                                                "date" : date,
                                                "newMessage" : "\(writeTV.text ?? "")",
                                                "newCount" : "\(Int(snapshot2!.data()!["newCount"] as! String)! + 1)",
                                            ])
                                        }
                                    }
                                    
                                    //다른 사람에게 메시지 보내기
                                    self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                                        "checkRead" : self.chatPresentUser.contains(i) ? true : false,
                                        "imgCheck" : self.imgCheck,
                                        "date" : date,
                                        "sender" : "\(self.appDelegate.phoneInfo!)",
                                        "message" : "\(writeTV.text ?? "")",
                                        "readList" : self.chatPresentUser
                                    ])
                                }
                            } else {
                                print(error!.localizedDescription)
                            }
                        }
                    }
                }
            } else {
                print(error3!.localizedDescription)
            }
        }
    }
    
    //MARK: 테이블 뷰 메소드
    
}
