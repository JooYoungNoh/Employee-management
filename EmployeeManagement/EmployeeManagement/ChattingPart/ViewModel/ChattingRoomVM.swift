//
//  ChattingRoomVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/26.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class ChattingRoomVM {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var listener: ListenerRegistration?              //리스너 삭제
    
    var activationStatus: Bool = false              //활성화 여부
    
    //채팅 리스트(bringChattingList)
    var chatList: [ChattingRoomModel] = []
    
    //읽은 사람 표시를 위한 변수(saveChattingInfo)
    var dbID: String = ""
    var dbReadList: [String] = []
    var dbOtherReadList: [String] = []
    var userProfileImgCheck: Bool = false
    let semaphore1 = DispatchSemaphore(value: 0)
    let group1 = DispatchGroup()
    
    //사진 보내기 버튼
    var dbImagePhone: [String] = []
    var dbImagecheck: String = ""
    var dbImageName: String = ""
    
    //firebase 저장 변수(활성화 했을 떄 상대방에게 방 생성) (doSendButton)
    var dbPhone: [String] = []
    var dbcheck: String = ""
    var dbName: String = ""
    var dbRoom: String = ""
    let semaphore = DispatchSemaphore(value: 0)
    let group = DispatchGroup()
    //내가 메시지 보낼때 있는 현재 인원
    var chatPresentUser: [String] = []
    var saveMessage: String = ""
    
    //(deletePresentUser)
    //인원들 아이디 저장 변수
    var dbResultID: String = ""
    //내가 방에서 나갈떄 있는 현재 인원
    var newpresentUser: [String] = []
    
    //(cellInfo)
    var allUserCount: String = ""
    var userName: String = ""
    var userImageList: [roomImageSave] = []
    var chatImageList: [chatImageSave] = []
    
    
    //MARK: 액션 메소드
    //MARK: 방 입장
    //채팅 읽음 정보 저장
    func saveChattingInfo(dbOnTable: String, phoneListOnTable: [String]){
        //방에 입장시 안읽은 메시지 갯수 0으로 바꾸기
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").updateData([
            "newCount" : "0"
        ])
        
        //메시지 각각 documentID에 정보 수정(읽은 사람 표시를 위함)
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").collection("chat").whereField("checkRead", isEqualTo: false).getDocuments { snapshot, error in
            if error == nil {
                for doc in snapshot!.documents {
                    self.dbReadList.removeAll()
                    self.dbReadList = doc.data()["readList"] as! [String]
                    self.dbReadList.append("\(self.appDelegate.phoneInfo!)")
                    
                    //Firebase에 저장
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").collection("chat").document("\(doc.documentID)").updateData([
                        "checkRead" : true,
                        "readList" : self.dbReadList
                    ])
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        //채팅방에 있는 다른 사람 정보 수정
        DispatchQueue.global().async {
            for i in phoneListOnTable{
                self.group1.enter()
                self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                    if error == nil {
                        self.dbID = ""
                        self.userProfileImgCheck = false
                        for doc in snapshot!.documents{
                            self.dbID = doc.documentID
                            self.userProfileImgCheck = doc.data()["profileImg"] as! Bool
                        }
                        //프로필 이미지 다운
                        self.profileDownloadimage(phone: i)
                        
                        self.db.collection("users").document("\(self.dbID)").collection("chattingList").document("\(dbOnTable)").collection("chat").getDocuments{ (snapshot2, error2) in
                            if error2 == nil {
                                self.dbOtherReadList.removeAll()
                                for doc in snapshot2!.documents{
                                    self.dbOtherReadList.removeAll()
                                    //읽은 사람 리스트에 이름이 없는 경우
                                    if (doc.data()["readList"] as! [String]).contains("\(self.appDelegate.phoneInfo!)") == false {
                                        self.dbOtherReadList = doc.data()["readList"] as! [String]
                                        self.dbOtherReadList.append("\(self.appDelegate.phoneInfo!)")
                                        self.db.collection("users").document("\(self.dbID)").collection("chattingList").document("\(dbOnTable)").collection("chat").document("\(doc.documentID)").updateData([
                                            "readList" : self.dbOtherReadList
                                        ])
                                    }
                                }
                                self.semaphore1.signal()
                                self.group1.leave()
                            } else {
                                print(error2!.localizedDescription)
                            }
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                }
                self.semaphore1.wait()
            }
            self.group1.notify(queue: DispatchQueue.main) {
                 print("끝")
            }
        }
    }
    
    //채팅 리스트 불러오기
    func bringChattingList(dbOnTable: String, activationOnTable: Bool, phoneListOnTable: [String], completion: @escaping([ChattingRoomModel]) -> () ){
        if activationOnTable == false && self.activationStatus == false {
            
        } else {
            self.activationStatus = true
            
            //채팅 읽음 정보 저장
            self.saveChattingInfo(dbOnTable: dbOnTable, phoneListOnTable: phoneListOnTable)
            
            self.listener = self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").collection("chat").order(by: "date", descending: false).addSnapshotListener({ snapshot, error in
                if error == nil && snapshot != nil{
                    self.chatList.removeAll()
                    
                    for doc in snapshot!.documents {
                        self.chatList.append(ChattingRoomModel.init(checkRead: doc.data()["checkRead"] as! Bool, imgCheck: doc.data()["imgCheck"] as! Bool, date: doc.data()["date"] as! TimeInterval, sender: doc.data()["sender"] as! String, message: doc.data()["message"] as? String ?? "", readList: doc.data()["readList"] as! [String]))
                    }
                    
                    //채팅이 이미지인 경우
                    for i in self.chatList{
                        if i.imgCheck == true {
                            self.chatDownloadimage(dbOnTable: dbOnTable, sender: i.sender, date: i.date)
                        }
                    }
                    
                    completion(self.chatList)
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    
    //프로필 이미지 다운
    func profileDownloadimage(phone: String){
        if self.userProfileImgCheck == false {
            if self.userImageList.isEmpty == true {
                self.userImageList.append(roomImageSave.init(userPhone: phone, userImage: UIImage(named: "account")!))
            } else {
                if self.userImageList.firstIndex(where: {$0.userPhone == phone}) == nil{
                    self.userImageList.append(roomImageSave.init(userPhone: phone, userImage: UIImage(named: "account")!))
                }
            }
        } else {
            self.storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/userprofile/\(phone)").downloadURL { (url, error) in
                if error == nil && url != nil {
                    let data = NSData(contentsOf: url!)
                    let dbImage = UIImage(data: data! as Data)
                    
                    if self.userImageList.isEmpty == true {
                        self.userImageList.append(roomImageSave.init(userPhone: phone, userImage: dbImage!))
                    } else {
                        if self.userImageList.firstIndex(where: {$0.userPhone == phone}) == nil{
                            self.userImageList.append(roomImageSave.init(userPhone: phone, userImage: dbImage!))
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    //전화변호로 이미지 찾기
    func findProfileImage(imgView: UIImageView, phone: String){
        if let index = self.userImageList.firstIndex(where: {$0.userPhone == phone}){
            imgView.image = self.userImageList[index].userImage
        }
    }
    
    //MARK: 기능 선택 버튼
    func selectFunction(uv: UIViewController){
        let alert = UIAlertController(title: "선택해주세요", message: nil, preferredStyle: .actionSheet)
        //모든 사진 보기
        alert.addAction(UIAlertAction(title: "모든 사진 보기", style: .default){ (_) in
            let sortedList = self.chatImageList.sorted(by: {$0.date > $1.date})
            self.appDelegate.imageList = sortedList
    
            let chatNV = uv.storyboard?.instantiateViewController(withIdentifier: "ChatNV")
            chatNV?.modalPresentationStyle = .fullScreen
            uv.present(chatNV!, animated: true)
        })
        
        //대화상대 초대
        alert.addAction(UIAlertAction(title: "대화상대 초대", style: .default){ (_) in
            
        })
        
        //채팅방 나가기
        alert.addAction(UIAlertAction(title: "채팅방 나가기", style: .default){ (_) in
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        uv.present(alert, animated: true)
    }
    
    //MARK: 사진 버튼
    //사진 선택 종류 후 메시지 업데이트
    func pictureMessageSend(dbIDOnTable: String, date: TimeInterval, phoneListOnTable: [String]){
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").getDocument { snapshot3, error3 in
            if error3 == nil {
                self.chatPresentUser.removeAll()
                self.chatPresentUser = (snapshot3!.data()!["presentUser"] as! [String])
                
                //내 채팅 리스트 정보 업데이트
                self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                    "date" : date,
                    "newMessage" : "사진",
                ])
                
                //내 채팅방 채팅 추가
                self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                    "checkRead" : true,
                    "imgCheck" : true,
                    "date" : date,
                    "sender" : "\(self.appDelegate.phoneInfo!)",
                    "message" : "",
                    "readList" : self.chatPresentUser
                ])
                
                DispatchQueue.global().async {
                    for i in phoneListOnTable {
                        self.group.enter()
                        self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                            if error == nil {
                                self.dbImagePhone.removeAll()
                                self.dbImagecheck = ""
                                self.dbImagePhone = phoneListOnTable
                                for doc in snapshot!.documents{
                                    self.dbImagecheck = doc.documentID
                                }
                                if let index = self.dbImagePhone.firstIndex(of: i){
                                    self.dbImagePhone.remove(at: index)
                                    self.dbImagePhone.append(self.appDelegate.phoneInfo!)
                                }
                                
                                //다른 사람 방 업데이트
                                if self.dbImagecheck != "" {
                                    self.db.collection("users").document("\(self.dbImagecheck)").collection("chattingList").document("\(dbIDOnTable)").getDocument { snapshot2, error2 in
                                        if error2 == nil {
                                            self.db.collection("users").document("\(self.dbImagecheck)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                                                "date" : date,
                                                "newMessage" : "사진",
                                                "newCount" : "\(self.chatPresentUser.contains(i) ? 0 : Int(snapshot2!.data()!["newCount"] as! String)! + 1)",
                                            ])
                                        }
                                    }
                                    
                                    //다른 사람에게 메시지 보내기
                                    self.db.collection("users").document("\(self.dbImagecheck)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                                        "checkRead" : self.chatPresentUser.contains(i) ? true : false,
                                        "imgCheck" : true,
                                        "date" : date,
                                        "sender" : "\(self.appDelegate.phoneInfo!)",
                                        "message" : "",
                                        "readList" : self.chatPresentUser
                                    ]) { (_) in
                                        self.semaphore.signal()
                                        self.group.leave()
                                    }
                                }
                            } else {
                                print(error!.localizedDescription)
                            }
                        }
                        self.semaphore.wait()
                    }
                    self.group.notify(queue: DispatchQueue.main) {
                         print("끝")
                    }
                }
            } else {
                print(error3!.localizedDescription)
            }
        }
    }
    
    //이미지 업로드(대화가 사진일 경우)
    func chatUploadimage(img: UIImage, dbIDOnTable: String, date: TimeInterval){
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)!
        
        let filePath = "chattingRoom/\(dbIDOnTable)/chat/\(self.appDelegate.phoneInfo!)_\(date)"
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        if self.chatImageList.isEmpty == true {
            self.chatImageList.append(chatImageSave.init(title: "\(self.appDelegate.phoneInfo!)_\(date)", image: img, date: date))
        } else {
            if self.chatImageList.firstIndex(where: {$0.title == "\(self.appDelegate.phoneInfo!)_\(date)"}) == nil{
                self.chatImageList.append(chatImageSave.init(title: "\(self.appDelegate.phoneInfo!)_\(date)", image: img, date: date))
            }
        }
        
        storage.reference().child(filePath).putData(data, metadata: metaData) { (metaData,error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("성공")
            }
        }
    }
    
    //이미지 다운로드(대화가 사진인 경우)
    func chatDownloadimage(dbOnTable: String, sender: String, date: TimeInterval){
        self.storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/chattingRoom/\(dbOnTable)/chat/\(sender)_\(date)").downloadURL { (url, error) in
            if error == nil && url != nil {
                let data = NSData(contentsOf: url!)
                let dbImage = UIImage(data: data! as Data)
                
                if self.chatImageList.isEmpty == true {
                    self.chatImageList.append(chatImageSave.init(title: "\(sender)_\(date)", image: dbImage!, date: date))
                } else {
                    if self.chatImageList.firstIndex(where: {$0.title == "\(sender)_\(date)"}) == nil{
                        self.chatImageList.append(chatImageSave.init(title: "\(sender)_\(date)", image: dbImage!, date: date))
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //전화변호로 이미지 찾기
    func findChatImage(imgView: UIImageView, sender: String, date: TimeInterval){
        if let index = self.chatImageList.firstIndex(where: {$0.title == "\(sender)_\(date)"}){
            imgView.image = self.chatImageList[index].image
        }
    }
    
    //리스너 여러개 달리는 오류해결(화면이 사라질때 리스너를 삭제)
    func deleteListner(){
        listener?.remove()
    }
    
    
    //MARK: 뒤로가기 버튼
    //현재 인원에서 이름 삭제
    func deletePresentUser(dbIDOnTable: String, phoneListOnTable: [String], activationOnTable: Bool){
        self.deleteListner()
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").getDocument { snapshot2, error2 in
            if error2 == nil {
                self.newpresentUser = (snapshot2!.data()!["presentUser"] as! [String])
                
                if let index = self.newpresentUser.firstIndex(of: self.appDelegate.phoneInfo!){
                    self.newpresentUser.remove(at: index)
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                        "presentUser" : self.newpresentUser
                    ])
                    if self.activationStatus == true || activationOnTable == true {
                        DispatchQueue.global().async {
                            for i in phoneListOnTable {
                                self.group.enter()
                                self.dbResultID = ""
                                self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                                    if error == nil {
                                        for doc in snapshot!.documents{
                                            self.dbResultID = doc.documentID
                                        }
                                        self.db.collection("users").document("\(self.dbResultID)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                                            "presentUser" : self.newpresentUser
                                        ]){ (_) in
                                            self.semaphore.signal()
                                            self.group.leave()
                                        }
                                    } else {
                                        print(error!.localizedDescription)
                                    }
                                }
                                self.semaphore.wait()
                            }
                            self.group.notify(queue: DispatchQueue.main) {
                                 print("끝")
                            }
                        }
                    }
                }
            } else {
                print(error2!.localizedDescription)
            }
        }
    }
    
    //MARK: 메시지 보내기 버튼
    func doSendButton(activationOnTable: Bool, phoneListOnTable: [String], roomTitleOnTable: String, dbIDOnTable: String, writeTV: UITextView, tableView: UITableView){
        let date = Date().timeIntervalSince1970
        
        self.saveMessage = writeTV.text
        
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").getDocument { snapshot3, error3 in
            if error3 == nil {
                self.chatPresentUser.removeAll()
                
                self.chatPresentUser = (snapshot3!.data()!["presentUser"] as! [String])
                
                //비 활성화 상태 일때
                if self.activationStatus == false && activationOnTable == false {
                    self.activationStatus = true
                    //내 채팅 리스트 정보 업데이트
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                        "date" : date,
                        "newMessage" : "\(self.saveMessage)",
                        "activation" : true
                    ])
                    
                    //내 채팅방 채팅 추가
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                        "checkRead" : true,
                        "imgCheck" : false,
                        "date" : date,
                        "sender" : "\(self.appDelegate.phoneInfo!)",
                        "message" : "\(self.saveMessage)",
                        "readList" : ["\(self.appDelegate.phoneInfo!)"]
                    ])
                    
                    //화면에 바로 보여주기
                    self.listener = self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").order(by: "date", descending: false).addSnapshotListener({ snapshot, error in
                        if error == nil && snapshot != nil{
                            self.chatList.removeAll()
                            
                            for doc in snapshot!.documents {
                                self.chatList.append(ChattingRoomModel.init(checkRead: doc.data()["checkRead"] as! Bool, imgCheck: doc.data()["imgCheck"] as! Bool, date: doc.data()["date"] as! TimeInterval, sender: doc.data()["sender"] as! String, message: doc.data()["message"] as? String ?? "", readList: doc.data()["readList"] as! [String]))
                            }
                            
                            tableView.reloadData()
                            tableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1, section: 0), at: .bottom, animated: true)
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                    
                    //다른 방 사람들에게 처음 메시지 보내기
                    DispatchQueue.global().async {
                        for i in phoneListOnTable {
                            self.group.enter()
                            self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                                if error == nil {
                                    self.dbPhone.removeAll()
                                    self.dbcheck = ""
                                    self.dbName = ""
                                    self.dbRoom = roomTitleOnTable
                                    self.dbPhone = phoneListOnTable
                                    
                                    for doc in snapshot!.documents{
                                        self.dbcheck = doc.documentID
                                        self.dbName = doc.data()["name"] as! String
                                    }
                            
                                    if let index = self.dbPhone.firstIndex(of: i){
                                        self.dbPhone.remove(at: index)
                                        self.dbPhone.append(self.appDelegate.phoneInfo!)
                                    }
                                    
                                    //방 생성
                                    if self.dbcheck != "" {
                                        self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").setData([
                                            "date" : date,
                                            "roomTitle" : self.dbRoom,
                                            "phoneList" : self.dbPhone,
                                            "memberCount" : "\(self.dbPhone.count + 1)",
                                            "newMessage" : "\(self.saveMessage)",
                                            "newCount" : "1",
                                            "activation" : true,
                                            "presentUser" : self.chatPresentUser
                                        ])
                                        //메시지 보내기
                                        self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                                            "checkRead" : false,
                                            "imgCheck" : false,
                                            "date" : date,
                                            "sender" : "\(self.appDelegate.phoneInfo!)",
                                            "message" : "\(self.saveMessage)",
                                            "readList" : ["\(self.appDelegate.phoneInfo!)"]
                                        ]) { (_) in
                                            self.semaphore.signal()
                                            self.group.leave()
                                        }
                                    }
                                } else {
                                    print(error!.localizedDescription)
                                }
                            }
                            self.semaphore.wait()
                        }
                        self.group.notify(queue: DispatchQueue.main) {
                             print("끝")
                        }
                    }
                } else {        //활성화 상태
                    //내 채팅 리스트 정보 업데이트
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                        "date" : date,
                        "newMessage" : "\(self.saveMessage)",
                    ])
                    
                    //내 채팅방 채팅 추가
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                        "checkRead" : true,
                        "imgCheck" : false,
                        "date" : date,
                        "sender" : "\(self.appDelegate.phoneInfo!)",
                        "message" : "\(self.saveMessage)",
                        "readList" : self.chatPresentUser
                    ])
                    
                    //다른 사람 방에 채팅 추가
                    DispatchQueue.global().async {
                        for i in phoneListOnTable {
                            self.group.enter()
                            self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                                if error == nil {
                                    self.dbcheck = ""
                                    
                                    for doc in snapshot!.documents{
                                        self.dbcheck = doc.documentID
                                    }
                                    print(self.dbcheck)
                                    //다른 사람 방 업데이트
                                    if self.dbcheck != "" {
                                        self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").getDocument { snapshot2, error2 in
                                            if error2 == nil {
                                                
                                                print(self.dbcheck)
                                                
                                                self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                                                    "date" : date,
                                                    "newMessage" : "\(self.saveMessage)",
                                                    "newCount" : "\(self.chatPresentUser.contains(i) ? 0 : (Int(snapshot2!.data()!["newCount"] as! String)! + 1))",
                                                ])
                                            } else {
                                                print(error2!.localizedDescription)
                                            }
                                        }
                                        
                                        //다른 사람에게 메시지 보내기
                                        self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                                            "checkRead" : self.chatPresentUser.contains(i) ? true : false,
                                            "imgCheck" : false,
                                            "date" : date,
                                            "sender" : "\(self.appDelegate.phoneInfo!)",
                                            "message" : "\(self.saveMessage)",
                                            "readList" : self.chatPresentUser
                                        ]) { _ in
                                            self.semaphore.signal()
                                            self.group.leave()
                                        }
                                    }
                                } else {
                                    print(error!.localizedDescription)
                                }
                            }
                            self.semaphore.wait()
                        }
                        self.group.notify(queue: DispatchQueue.main) {
                             print("끝")
                        }
                    }
                }
            } else {
                print(error3!.localizedDescription)
            }
        }
    }
    
    //MARK: 테이블 뷰 메소드
    //셀 정보
    func cellInfo(tableView: UITableView, indexPath: IndexPath, dbOnTable: String) -> UITableViewCell {
        
        //시간 정제
        let date = Date(timeIntervalSince1970: self.chatList[indexPath.row].date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let fixDate = "\(formatter.string(from: date))"
        
        if self.chatList[indexPath.row].sender == "invitation" {      //초대할 경우
            //TODO: 나중에 사람 초대 기능 넣을 경우(가운데에 셀에 레이블도 하나 만들어야됨
            //cell도 바꾸기
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingRoomCell.identifier, for: indexPath) as? ChattingRoomCell else { return UITableViewCell() }
            
            return cell
            
        } else if self.chatList[indexPath.row].sender == "\(self.appDelegate.phoneInfo!)" {             //보낸사람이 나인 경우
            
            if self.chatList[indexPath.row].imgCheck == true {  //메시지가 사진인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingRoomRightPictureCell.identifier, for: indexPath) as? ChattingRoomRightPictureCell else { return UITableViewCell() }
                
                DispatchQueue.main.async {
                    self.findChatImage(imgView: cell.rightTalkImageView, sender: self.chatList[indexPath.row].sender, date: self.chatList[indexPath.row].date)
                }
                cell.rightTime.text = fixDate
                
                //채팅 본 사람 인원 계산
                self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").getDocument { snapshot, error in
                    if error == nil {
                        self.allUserCount = (snapshot!.data()!["memberCount"] as! String)
                        let changeUserCount = Int(self.allUserCount)! - self.chatList[indexPath.row].readList.count
                        
                        cell.rightcheck.text = changeUserCount < 1 ? "" : "\(changeUserCount)"
                    } else {
                        print(error!.localizedDescription)
                    }
                }
                
                return cell
                
            } else {                                           //사진이 아닌 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingRoomCell.identifier, for: indexPath) as? ChattingRoomCell else { return UITableViewCell() }
                
                
                cell.rightTalkBox.text = self.chatList[indexPath.row].message
                cell.rightTime.text = fixDate
                
                //채팅 본 사람 인원 계산
                self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").getDocument { snapshot, error in
                    if error == nil {
                        self.allUserCount = (snapshot!.data()!["memberCount"] as! String)
                        let changeUserCount = Int(self.allUserCount)! - self.chatList[indexPath.row].readList.count
                        
                        cell.rightcheck.text = changeUserCount < 1 ? "" : "\(changeUserCount)"
                    } else {
                        print(error!.localizedDescription)
                    }
                }
                
                return cell
            }
        } else {                       //보낸 사람이 내가 아닌경우
            if self.chatList[indexPath.row].imgCheck == true {     //대화가 사진인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingRoomLeftPictureCell.identifier, for: indexPath) as? ChattingRoomLeftPictureCell else { return UITableViewCell() }
                
                DispatchQueue.main.async {
                    self.findChatImage(imgView: cell.leftTalkImageView, sender: self.chatList[indexPath.row].sender, date: self.chatList[indexPath.row].date)
                }
                cell.leftTime.text = fixDate
                
                //채팅 본 사람 인원 계산
                self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").getDocument { snapshot, error in
                    if error == nil {
                        self.allUserCount = (snapshot!.data()!["memberCount"] as! String)
                        let changeUserCount = Int(self.allUserCount)! - self.chatList[indexPath.row].readList.count
                        
                        cell.leftcheck.text = changeUserCount < 1 ? "" : "\(changeUserCount)"
                    } else {
                        print(error!.localizedDescription)
                    }
                }
                
                //채팅친 사람 이름
                self.db.collection("users").whereField("phone", isEqualTo: "\(self.chatList[indexPath.row].sender)").getDocuments { snapshot, error in
                    if error == nil {
                        for doc in snapshot!.documents{
                            self.userName = doc.data()["name"] as! String
                        }
                        cell.leftnameLabel.text = self.userName
                    } else {
                        print(error!.localizedDescription)
                    }
                }
                DispatchQueue.main.async {
                    self.findProfileImage(imgView: cell.leftImageView, phone: self.chatList[indexPath.row].sender)
                }
                
                return cell
            } else {                                               //사진이 아닌 경우
                if indexPath.row == 0 {                            //row가 0일 때
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingRoomLeftCell.identifier, for: indexPath) as? ChattingRoomLeftCell else { return UITableViewCell() }
                
                    
                    cell.leftTalkBox.text = self.chatList[indexPath.row].message
                    cell.leftTime.text = fixDate
                    
                    //채팅 본 사람 인원 계산
                    self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").getDocument { snapshot, error in
                        if error == nil {
                            self.allUserCount = (snapshot!.data()!["memberCount"] as! String)
                            let changeUserCount = Int(self.allUserCount)! - self.chatList[indexPath.row].readList.count
                            
                            cell.leftcheck.text = changeUserCount < 1 ? "" : "\(changeUserCount)"
                        } else {
                            print(error!.localizedDescription)
                        }
                    }
                    
                    //채팅친 사람 이름
                    self.db.collection("users").whereField("phone", isEqualTo: "\(self.chatList[indexPath.row].sender)").getDocuments { snapshot, error in
                        if error == nil {
                            for doc in snapshot!.documents{
                                self.userName = doc.data()["name"] as! String
                            }
                            cell.leftnameLabel.text = self.userName
                        } else {
                            print(error!.localizedDescription)
                        }
                    }
                    DispatchQueue.main.async {
                        self.findProfileImage(imgView: cell.leftImageView, phone: self.chatList[indexPath.row].sender)
                    }
                    return cell

                } else {
                    if self.chatList[indexPath.row].sender == self.chatList[indexPath.row - 1].sender {  //전 셀과 보낸사람이 같을때
                        
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingRoomSamePersonCell.identifier, for: indexPath) as? ChattingRoomSamePersonCell else { return UITableViewCell() }
                        
                        cell.leftTalkBox.text = self.chatList[indexPath.row].message
                        cell.leftTime.text = fixDate
                        
                        //채팅 본 사람 인원 계산
                        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").getDocument { snapshot, error in
                            if error == nil {
                                self.allUserCount = (snapshot!.data()!["memberCount"] as! String)
                                let changeUserCount = Int(self.allUserCount)! - self.chatList[indexPath.row].readList.count
                                
                                cell.leftcheck.text = changeUserCount < 1 ? "" : "\(changeUserCount)"
                            } else {
                                print(error!.localizedDescription)
                            }
                        }
                        return cell
                    } else {                                       //다를 때
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingRoomLeftCell.identifier, for: indexPath) as? ChattingRoomLeftCell else { return UITableViewCell() }
                        
                        cell.leftTalkBox.text = self.chatList[indexPath.row].message
                        cell.leftTime.text = fixDate
                        
                        //채팅 본 사람 인원 계산
                        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").getDocument { snapshot, error in
                            if error == nil {
                                self.allUserCount = (snapshot!.data()!["memberCount"] as! String)
                                let changeUserCount = Int(self.allUserCount)! - self.chatList[indexPath.row].readList.count
                                
                                cell.leftcheck.text = changeUserCount < 1 ? "" : "\(changeUserCount)"
                            } else {
                                print(error!.localizedDescription)
                            }
                        }
                        
                        //채팅친 사람 이름
                        self.db.collection("users").whereField("phone", isEqualTo: "\(self.chatList[indexPath.row].sender)").getDocuments { snapshot, error in
                            if error == nil {
                                for doc in snapshot!.documents{
                                    self.userName = doc.data()["name"] as! String
                                }
                                cell.leftnameLabel.text = self.userName
                            } else {
                                print(error!.localizedDescription)
                            }
                        }
                        DispatchQueue.main.async {
                            self.findProfileImage(imgView: cell.leftImageView, phone: self.chatList[indexPath.row].sender)
                        }
                        return cell
                    }
                }
            }
        }
    }
    
    //테이블 뷰 섹션에 나타낼 로우 갯수
    func numberOfRowsInSection() -> Int {
        return self.chatList.count
    }
    
    
    //MARK: 텍스트 뷰 메소드
    func textViewDidChange(textView: UITextView, sendButton: UIButton, textviewHeight: CGFloat, tableview: UITableView) {
        if textView.text == ""{
            sendButton.isHidden = true
        } else {
            sendButton.isHidden = false
        }
        
        if textviewHeight != textView.bounds.height {
            tableview.scrollToRow(at: IndexPath.init(row: self.chatList.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    
}
