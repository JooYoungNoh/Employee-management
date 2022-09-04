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
    
    var listner: ListenerRegistration?              //리스너 삭제
    
    var activationStatus: Bool = false              //활성화 여부
    var imgCheck: Bool = false                      //이미지 유무
    
    //채팅 리스트(bringChattingList)
    var chatList: [ChattingRoomModel] = []
    
    //읽은 사람 표시를 위한 변수(saveChattingInfo)
    var dbID: String = ""
    var dbReadList: [String] = []
    var dbOtherReadList: [String] = []
    var userImageList: [roomImageSave] = []
    var userProfileImgCheck: Bool = false
    
    //firebase 저장 변수(활성화 했을 떄 상대방에게 방 생성) (doSendButton)
    var dbPhone: [String] = []
    var dbcheck: String = ""
    var dbName: String = ""
    var dbRoom: String = ""
    //내가 메시지 보낼때 있는 현재 인원
    var chatPresentUser: [String] = []
    
    //(deletePresentUser)
    //인원들 아이디 저장 변수
    var dbResultID: String = ""
    //내가 방에서 나갈떄 있는 현재 인원
    var newpresentUser: [String] = []
    
    //(cellInfo)
    var allUserCount: String = ""
    var userName: String = ""
    
    
    //MARK: 액션 메소드
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
        for i in phoneListOnTable{
            self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                if error == nil {
                    for doc in snapshot!.documents{
                        self.dbID = doc.documentID
                        self.userProfileImgCheck = doc.data()["profileImg"] as! Bool
                    }
                    //프로필 이미지 다운
                    self.profileDownloadimage(phone: i)
                    
                    self.db.collection("users").document("\(self.dbID)").collection("chattingList").document("\(dbOnTable)").collection("chat").getDocuments(completion: { snapshot, error in
                        if error == nil {
                            for doc in snapshot!.documents{
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
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                } else {
                    print(error!.localizedDescription)
                }
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
            
            self.listner = self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").collection("chat").order(by: "date", descending: false).addSnapshotListener({ snapshot, error in
                if error == nil && snapshot != nil{
                    self.chatList.removeAll()
                    
                    for doc in snapshot!.documents {
                        self.chatList.append(ChattingRoomModel.init(checkRead: doc.data()["checkRead"] as! Bool, imgCheck: doc.data()["imgCheck"] as! Bool, date: doc.data()["date"] as! TimeInterval, sender: doc.data()["sender"] as! String, message: doc.data()["message"] as? String ?? "", readList: doc.data()["readList"] as! [String]))
                    }
                    
                   /* //채팅이 이미지인 경우
                    for i in self.chatList{
                        if i.imgCheck == true {
                            self.profileDownloadimage(phone: y)
                        }
                    }*/
                    
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
    func findImage(imgView: UIImageView, phone: String){
        if let index = self.userImageList.firstIndex(where: {$0.userPhone == phone}){
            imgView.image = self.userImageList[index].userImage
        }
    }
    
    //리스너 여러개 달리는 오류해결(화면이 사라질때 리스너를 삭제)
    func deleteListner(){
        listner?.remove()
    }
    
    
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
    //셀 정보
    func cellInfo(tableView: UITableView, indexPath: IndexPath, dbOnTable: String) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingRoomCell.identifier, for: indexPath) as? ChattingRoomCell else { return UITableViewCell() }
        
        //셀 기존 구조 초기화
        cell.rightTalkBox.snp.removeConstraints()
        cell.rightTime.snp.removeConstraints()
        cell.rightcheck.snp.removeConstraints()
        cell.leftImageView.snp.removeConstraints()
        cell.leftnameLabel.snp.removeConstraints()
        cell.leftTalkBox.snp.removeConstraints()
        cell.leftTime.snp.removeConstraints()
        cell.leftcheck.snp.removeConstraints()
        
        if self.chatList[indexPath.row].sender == "invitation" {      //초대할 경우
            //TODO: 나중에 사람 초대 기능 넣을 경우(가운데에 셀에 레이블도 하나 만들어야됨
            
            
        } else if self.chatList[indexPath.row].sender == "\(self.appDelegate.phoneInfo!)" {             //보낸사람이 나인 경우
            cell.rightTalkBox.isHidden = false
            cell.rightTime.isHidden = false
            cell.rightcheck.isHidden = false
            //셀 구조 재설정
            cell.rightTalkBox.snp.makeConstraints { make in
                make.top.equalTo(cell.snp.top).offset(10)
                make.trailing.equalTo(cell.snp.trailing).offset(-10)
                make.height.greaterThanOrEqualTo(50)
                make.width.lessThanOrEqualTo(200)
            }
            
            cell.rightTime.snp.makeConstraints { make in
                make.bottom.equalTo(cell.rightTalkBox.snp.bottom)
                make.trailing.equalTo(cell.rightTalkBox.snp.leading).offset(-5)
                make.height.equalTo(30)
                make.width.equalTo(70)
            }
            cell.rightcheck.snp.makeConstraints { make in
                make.bottom.equalTo(cell.rightTime.snp.top).offset(-2)
                make.trailing.equalTo(cell.rightTalkBox.snp.leading).offset(-5)
                make.height.equalTo(10)
                make.width.equalTo(30)
            }
            //시간 정제
            let date = Date(timeIntervalSince1970: self.chatList[indexPath.row].date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let fixDate = "\(formatter.string(from: date))"
            
            cell.rightTalkBox.text = self.chatList[indexPath.row].message
            cell.rightTime.text = fixDate
            
            self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").getDocument { snapshot, error in
                if error == nil {
                    self.allUserCount = (snapshot!.data()!["memberCount"] as! String)
                    let changeUserCount = Int(self.allUserCount)! - self.chatList[indexPath.row].readList.count
                    
                    cell.rightcheck.text = changeUserCount < 1 ? "" : "\(changeUserCount)"
                } else {
                    print(error!.localizedDescription)
                }
            }
        } else {                       //보낸 사람이 내가 아닌경우
            
            //시간 정제
            let date = Date(timeIntervalSince1970: self.chatList[indexPath.row].date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let fixDate = "\(formatter.string(from: date))"
            
            cell.leftTalkBox.text = self.chatList[indexPath.row].message
            cell.leftTime.text = fixDate
            
            self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbOnTable)").getDocument { snapshot, error in
                if error == nil {
                    self.allUserCount = (snapshot!.data()!["memberCount"] as! String)
                    let changeUserCount = Int(self.allUserCount)! - self.chatList[indexPath.row].readList.count
                    
                    cell.leftcheck.text = changeUserCount < 1 ? "" : "\(changeUserCount)"
                } else {
                    print(error!.localizedDescription)
                }
            }
            
            if indexPath.row == 0 {                                //row가 0일 때
                cell.leftImageView.isHidden = false
                cell.leftnameLabel.isHidden = false
                cell.leftTalkBox.isHidden = false
                cell.leftTime.isHidden = false
                cell.leftcheck.isHidden = false
                
                //셀 구조 재설정
                cell.leftImageView.snp.makeConstraints { make in
                    make.top.equalTo(cell.snp.top).offset(8)
                    make.leading.equalTo(cell.snp.leading).offset(10)
                    make.width.height.equalTo(40)
                }
                cell.leftnameLabel.snp.makeConstraints { make in
                    make.top.equalTo(cell.snp.top).offset(5)
                    make.leading.equalTo(cell.leftImageView.snp.trailing).offset(5)
                    make.height.equalTo(20)
                    make.width.lessThanOrEqualTo(150)
                }
                cell.leftTalkBox.snp.makeConstraints { make in
                    make.top.equalTo(cell.leftnameLabel.snp.bottom).offset(5)
                    make.leading.equalTo(cell.leftImageView.snp.trailing).offset(5)
                    make.height.greaterThanOrEqualTo(50)
                    make.width.lessThanOrEqualTo(150)
                }
                cell.leftTime.snp.makeConstraints { make in
                    make.bottom.equalTo(cell.leftTalkBox.snp.bottom)
                    make.leading.equalTo(cell.leftTalkBox.snp.trailing).offset(5)
                    make.height.equalTo(30)
                    make.width.equalTo(70)
                }
                cell.leftcheck.snp.makeConstraints { make in
                    make.bottom.equalTo(cell.leftTime.snp.top).offset(-2)
                    make.leading.equalTo(cell.leftTalkBox.snp.trailing).offset(5)
                    make.height.equalTo(20)
                    make.width.equalTo(30)
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
                    self.findImage(imgView: cell.leftImageView, phone: self.chatList[indexPath.row].sender)
                }

            } else {
                if self.chatList[indexPath.row].sender == self.chatList[indexPath.row - 1].sender {  //전 셀과 보낸사람이 같을때
                    cell.leftTalkBox.isHidden = false
                    cell.leftTime.isHidden = false
                    cell.leftcheck.isHidden = false
                    
                    //셀 구조 재설정
                    cell.leftTalkBox.snp.makeConstraints { make in
                        make.top.equalTo(cell.snp.top).offset(10)
                        make.leading.equalTo(cell.snp.leading).offset(55)
                        make.height.greaterThanOrEqualTo(50)
                        make.width.lessThanOrEqualTo(150)
                    }
                    cell.leftTime.snp.makeConstraints { make in
                        make.bottom.equalTo(cell.leftTalkBox.snp.bottom)
                        make.leading.equalTo(cell.leftTalkBox.snp.trailing).offset(5)
                        make.height.equalTo(30)
                        make.width.equalTo(70)
                    }
                    cell.leftcheck.snp.makeConstraints { make in
                        make.bottom.equalTo(cell.leftTime.snp.top).offset(-2)
                        make.leading.equalTo(cell.leftTalkBox.snp.trailing).offset(5)
                        make.height.equalTo(20)
                        make.width.equalTo(30)
                    }
                    
                } else {                                       //다를 때
                    cell.leftImageView.isHidden = false
                    cell.leftnameLabel.isHidden = false
                    cell.leftTalkBox.isHidden = false
                    cell.leftTime.isHidden = false
                    cell.leftcheck.isHidden = false
                    
                    //셀 구조 재설정
                    cell.leftImageView.snp.makeConstraints { make in
                        make.top.equalTo(cell.snp.top).offset(8)
                        make.leading.equalTo(cell.snp.leading).offset(10)
                        make.width.height.equalTo(40)
                    }
                    cell.leftnameLabel.snp.makeConstraints { make in
                        make.top.equalTo(cell.snp.top).offset(5)
                        make.leading.equalTo(cell.leftImageView.snp.trailing).offset(5)
                        make.height.equalTo(20)
                        make.width.lessThanOrEqualTo(150)
                    }
                    cell.leftTalkBox.snp.makeConstraints { make in
                        make.top.equalTo(cell.leftnameLabel.snp.bottom).offset(5)
                        make.leading.equalTo(cell.leftImageView.snp.trailing).offset(5)
                        make.height.greaterThanOrEqualTo(50)
                        make.width.lessThanOrEqualTo(150)
                    }
                    cell.leftTime.snp.makeConstraints { make in
                        make.bottom.equalTo(cell.leftTalkBox.snp.bottom)
                        make.leading.equalTo(cell.leftTalkBox.snp.trailing).offset(5)
                        make.height.equalTo(30)
                        make.width.equalTo(70)
                    }
                    cell.leftcheck.snp.makeConstraints { make in
                        make.bottom.equalTo(cell.leftTime.snp.top).offset(-2)
                        make.leading.equalTo(cell.leftTalkBox.snp.trailing).offset(5)
                        make.height.equalTo(20)
                        make.width.equalTo(30)
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
                        self.findImage(imgView: cell.leftImageView, phone: self.chatList[indexPath.row].sender)
                    }
                }
                
            }
            
        }
        
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        return cell
    }
    
    //테이블 뷰 섹션에 나타낼 로우 갯수
    func numberOfRowsInSection() -> Int {
        return self.chatList.count
    }
    
}
