//
//  ChattingVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/18.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class ChattingVM {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var listner: ListenerRegistration?              //리스너 삭제
    
    var checkReload: Bool = false
    var chattingList: [ChattingModel] = []
    var searchChattingList: [ChattingModel] = []
    
    var dbResultID: String = ""
    
    var userImageList: [imageSave] = []
    
    var userProfileImgCheck: Bool = false
    
    //MARK: 액션 메소드
    //채팅방 리스트 불러오기
    func bringChattingList(completion: @escaping([ChattingModel]) -> () ){
        //구조체 배열 초기화
        
        self.listner = self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").order(by: "date", descending: true).addSnapshotListener { (snapShot, error) in
            if error == nil && snapShot != nil{
                self.chattingList.removeAll()
                self.searchChattingList.removeAll()
                
                for doc in snapShot!.documents{
                    self.chattingList.append(ChattingModel.init(activation: doc.data()["activation"] as! Bool, date: doc.data()["date"] as! TimeInterval, memberCount: doc.data()["memberCount"] as! String, newCount: doc.data()["newCount"] as! String, newMessage: doc.data()["newMessage"] as! String, roomTitle: doc.data()["roomTitle"] as! String, phoneList: doc.data()["phoneList"] as! [String], presentUser: doc.data()["presentUser"] as! [String], type: doc.data()["type"] as? String ?? "", dbID: doc.documentID))
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
        }
    }
    
    func profileDownloadimage(phone: String){
        self.db.collection("users").whereField("phone", isEqualTo: phone).getDocuments { snapShot, error in
            if error == nil {
                for doc in snapShot!.documents{
                    self.userProfileImgCheck = doc.data()["profileImg"] as! Bool
                }
                if self.userProfileImgCheck == false {
                    if self.userImageList.isEmpty == true {
                        self.userImageList.append(imageSave.init(userPhone: phone, userImage: UIImage(named: "account")!))
                    } else {
                        if self.userImageList.firstIndex(where: {$0.userPhone == phone}) == nil{
                            self.userImageList.append(imageSave.init(userPhone: phone, userImage: UIImage(named: "account")!))
                        }
                    }
                } else {
                    self.storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/userprofile/\(phone)").downloadURL { (url, error) in
                        if error == nil && url != nil {
                            let data = NSData(contentsOf: url!)
                            let dbImage = UIImage(data: data! as Data)
                            
                            if self.userImageList.isEmpty == true {
                                self.userImageList.append(imageSave.init(userPhone: phone, userImage: dbImage!))
                            } else {
                                if self.userImageList.firstIndex(where: {$0.userPhone == phone}) == nil{
                                    self.userImageList.append(imageSave.init(userPhone: phone, userImage: dbImage!))
                                }
                            }
                        } else {
                            print(error!.localizedDescription)
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
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
    
    func addChatting(uv: UIViewController){
        guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "CreateChatVC") as? CreateChatVC else { return }
        nv.modalPresentationStyle = .fullScreen
        
        uv.present(nv, animated: true)
    }
    
    //MARK: 테이블 뷰 메소드
     func cellInfo(tableView: UITableView, indexPath: IndexPath, isFiltering: Bool) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingCell.identifier, for: indexPath) as? ChattingCell else { return UITableViewCell() }
         
         cell.userImageView.image = UIImage(named: "account")
         cell.userTwoImageView1.image = UIImage(named: "account")
         cell.userTwoImageView2.image = UIImage(named: "account")
         cell.userThreeImageView1.image = UIImage(named: "account")
         cell.userThreeImageView2.image = UIImage(named: "account")
         cell.userThreeImageView3.image = UIImage(named: "account")
         cell.userFourImageView1.image = UIImage(named: "account")
         cell.userFourImageView2.image = UIImage(named: "account")
         cell.userFourImageView3.image = UIImage(named: "account")
         cell.userFourImageView4.image = UIImage(named: "account")
         
         if isFiltering == false {
             if self.chattingList.isEmpty == true {
                 cell.titleLabel.text = "채팅방이 없습니다."
                 cell.titleLabel.textColor = .red
                 cell.commentLabel.text = "생성해주세여~"
                 cell.commentLabel.textColor = .red
                 cell.dateLabel.text = ""
                 cell.userCount.text = ""
                 cell.newMessageCount.isHidden = true
                 cell.userImageView.isHidden = true
                 cell.userTwoImageView1.isHidden = true
                 cell.userTwoImageView2.isHidden = true
                 cell.userThreeImageView1.isHidden = true
                 cell.userThreeImageView2.isHidden = true
                 cell.userThreeImageView3.isHidden = true
                 cell.userFourImageView1.isHidden = true
                 cell.userFourImageView2.isHidden = true
                 cell.userFourImageView3.isHidden = true
                 cell.userFourImageView4.isHidden = true
             } else {
                 let date = Date(timeIntervalSince1970: self.chattingList[indexPath.row].date) + 32400
                 
                 let formatter = DateFormatter()
                 formatter.dateFormat = "yyyy-MM-dd"
                 formatter.timeZone = TimeZone(identifier: "UTC")
                 let fixDate = "\(formatter.string(from: date))"
                 
                 //방 제목
                 cell.titleLabel.text = self.chattingList[indexPath.row].roomTitle
                 cell.titleLabel.textColor = .black
                 
                 //유저 수
                 if self.chattingList[indexPath.row].memberCount != "2" {
                     if self.chattingList[indexPath.row].memberCount == "1"{
                         cell.userCount.text = "(방에 아무도 없습니다)"
                     } else {
                         cell.userCount.text = self.chattingList[indexPath.row].memberCount
                     }
                 }
                 
                 //방 업데이트 날짜
                 cell.dateLabel.text = fixDate
                 
                 //새로운 메시지 갯수
                 if self.chattingList[indexPath.row].newCount != "0" {
                     cell.newMessageCount.isHidden = false
                     cell.newMessageCount.text = self.chattingList[indexPath.row].newCount
                 } else {
                     cell.newMessageCount.isHidden = true
                 }
                 
                 //메시지
                 if self.chattingList[indexPath.row].activation == false {
                     cell.commentLabel.text = "채팅을 입력하여 방을 활성화해주세요"
                 } else {
                     cell.commentLabel.text = self.chattingList[indexPath.row].newMessage
                 }
                 cell.commentLabel.textColor = .systemGray
                 
                 //방 프로필 이미지
                 DispatchQueue.main.async {
                     switch self.chattingList[indexPath.row].memberCount {
                     case "1":
                         cell.userImageView.isHidden = false
                         cell.userTwoImageView1.isHidden = true
                         cell.userTwoImageView2.isHidden = true
                         cell.userThreeImageView1.isHidden = true
                         cell.userThreeImageView2.isHidden = true
                         cell.userThreeImageView3.isHidden = true
                         cell.userFourImageView1.isHidden = true
                         cell.userFourImageView2.isHidden = true
                         cell.userFourImageView3.isHidden = true
                         cell.userFourImageView4.isHidden = true
                         cell.userImageView.image = UIImage(named: "account")
                     case "2":
                         cell.userImageView.isHidden = false
                         cell.userTwoImageView1.isHidden = true
                         cell.userTwoImageView2.isHidden = true
                         cell.userThreeImageView1.isHidden = true
                         cell.userThreeImageView2.isHidden = true
                         cell.userThreeImageView3.isHidden = true
                         cell.userFourImageView1.isHidden = true
                         cell.userFourImageView2.isHidden = true
                         cell.userFourImageView3.isHidden = true
                         cell.userFourImageView4.isHidden = true
                         self.findImage(imgView: cell.userImageView, phone: self.chattingList[indexPath.row].phoneList[0])
                     case "3":
                         cell.userImageView.isHidden = true
                         cell.userTwoImageView1.isHidden = false
                         cell.userTwoImageView2.isHidden = false
                         cell.userThreeImageView1.isHidden = true
                         cell.userThreeImageView2.isHidden = true
                         cell.userThreeImageView3.isHidden = true
                         cell.userFourImageView1.isHidden = true
                         cell.userFourImageView2.isHidden = true
                         cell.userFourImageView3.isHidden = true
                         cell.userFourImageView4.isHidden = true
                         self.findImage(imgView: cell.userTwoImageView1, phone: self.chattingList[indexPath.row].phoneList[0])
                         self.findImage(imgView: cell.userTwoImageView2, phone: self.chattingList[indexPath.row].phoneList[1])
                     case "4":
                         cell.userImageView.isHidden = true
                         cell.userTwoImageView1.isHidden = true
                         cell.userTwoImageView2.isHidden = true
                         cell.userThreeImageView1.isHidden = false
                         cell.userThreeImageView2.isHidden = false
                         cell.userThreeImageView3.isHidden = false
                         cell.userFourImageView1.isHidden = true
                         cell.userFourImageView2.isHidden = true
                         cell.userFourImageView3.isHidden = true
                         cell.userFourImageView4.isHidden = true

                         self.findImage(imgView: cell.userThreeImageView1, phone: self.chattingList[indexPath.row].phoneList[0])
                         self.findImage(imgView: cell.userThreeImageView2, phone: self.chattingList[indexPath.row].phoneList[1])
                         self.findImage(imgView: cell.userThreeImageView3, phone: self.chattingList[indexPath.row].phoneList[2])
                     default:
                         cell.userImageView.isHidden = true
                         cell.userTwoImageView1.isHidden = true
                         cell.userTwoImageView2.isHidden = true
                         cell.userThreeImageView1.isHidden = true
                         cell.userThreeImageView2.isHidden = true
                         cell.userThreeImageView3.isHidden = true
                         cell.userFourImageView1.isHidden = false
                         cell.userFourImageView2.isHidden = false
                         cell.userFourImageView3.isHidden = false
                         cell.userFourImageView4.isHidden = false
                         
                         self.findImage(imgView: cell.userFourImageView1, phone: self.chattingList[indexPath.row].phoneList[0])
                         self.findImage(imgView: cell.userFourImageView2, phone: self.chattingList[indexPath.row].phoneList[1])
                         self.findImage(imgView: cell.userFourImageView3, phone: self.chattingList[indexPath.row].phoneList[2])
                         self.findImage(imgView: cell.userFourImageView4, phone: self.chattingList[indexPath.row].phoneList[3])
                     }

                 }
             }
         } else {
             if self.searchChattingList.isEmpty == true {
                 cell.titleLabel.text = "검색 결과가 없습니다"
                 cell.titleLabel.textColor = .red
                 cell.dateLabel.text = ""
                 cell.newMessageCount.isHidden = true
                 cell.userImageView.isHidden = true
                 cell.userTwoImageView1.isHidden = true
                 cell.userTwoImageView2.isHidden = true
                 cell.userThreeImageView1.isHidden = true
                 cell.userThreeImageView2.isHidden = true
                 cell.userThreeImageView3.isHidden = true
                 cell.userFourImageView1.isHidden = true
                 cell.userFourImageView2.isHidden = true
                 cell.userFourImageView3.isHidden = true
                 cell.userFourImageView4.isHidden = true
             } else {
                 let date2 = Date(timeIntervalSince1970: self.searchChattingList[indexPath.row].date) + 32400
                 let formatter = DateFormatter()
                 formatter.dateFormat = "yyyy-MM-dd"
                 formatter.timeZone = TimeZone(identifier: "UTC")
                 
                 let fixDate2 = "\(formatter.string(from: date2))"
                 
                 //방 제목
                 cell.titleLabel.text = self.searchChattingList[indexPath.row].roomTitle
                 cell.titleLabel.textColor = .black
                 
                 //유저 수
                 if self.searchChattingList[indexPath.row].memberCount != "2" {
                     if self.searchChattingList[indexPath.row].memberCount == "1"{
                         cell.userCount.text = "(방에 아무도 없습니다)"
                     } else {
                         cell.userCount.text = self.searchChattingList[indexPath.row].memberCount
                     }
                 }
                 
                 //방 업데이트 날짜
                 cell.dateLabel.text = fixDate2
                 
                 //새로운 메시지 갯수
                 if self.searchChattingList[indexPath.row].newCount != "0" {
                     cell.newMessageCount.isHidden = false
                     cell.newMessageCount.text = self.searchChattingList[indexPath.row].newCount
                 } else {
                     cell.newMessageCount.isHidden = true
                 }
                 
                 //메시지
                 if self.searchChattingList[indexPath.row].activation == false {
                     cell.commentLabel.text = "채팅을 입력하여 방을 활성화해주세요"
                 } else {
                     cell.commentLabel.text = self.searchChattingList[indexPath.row].newMessage
                 }
                 cell.commentLabel.textColor = .systemGray
                 
                 //방 프로필 이미지
                 DispatchQueue.main.async {
                     switch self.searchChattingList[indexPath.row].memberCount {
                     case "1":
                         cell.userImageView.isHidden = false
                         cell.userTwoImageView1.isHidden = true
                         cell.userTwoImageView2.isHidden = true
                         cell.userThreeImageView1.isHidden = true
                         cell.userThreeImageView2.isHidden = true
                         cell.userThreeImageView3.isHidden = true
                         cell.userFourImageView1.isHidden = true
                         cell.userFourImageView2.isHidden = true
                         cell.userFourImageView3.isHidden = true
                         cell.userFourImageView4.isHidden = true
                         cell.userImageView.image = UIImage(named: "account")
                     case "2":
                         cell.userImageView.isHidden = false
                         cell.userTwoImageView1.isHidden = true
                         cell.userTwoImageView2.isHidden = true
                         cell.userThreeImageView1.isHidden = true
                         cell.userThreeImageView2.isHidden = true
                         cell.userThreeImageView3.isHidden = true
                         cell.userFourImageView1.isHidden = true
                         cell.userFourImageView2.isHidden = true
                         cell.userFourImageView3.isHidden = true
                         cell.userFourImageView4.isHidden = true
                         self.findImage(imgView: cell.userImageView, phone: self.searchChattingList[indexPath.row].phoneList[0])
                     case "3":
                         cell.userImageView.isHidden = true
                         cell.userTwoImageView1.isHidden = false
                         cell.userTwoImageView2.isHidden = false
                         cell.userThreeImageView1.isHidden = true
                         cell.userThreeImageView2.isHidden = true
                         cell.userThreeImageView3.isHidden = true
                         cell.userFourImageView1.isHidden = true
                         cell.userFourImageView2.isHidden = true
                         cell.userFourImageView3.isHidden = true
                         cell.userFourImageView4.isHidden = true
                         self.findImage(imgView: cell.userTwoImageView1, phone: self.searchChattingList[indexPath.row].phoneList[0])
                         self.findImage(imgView: cell.userTwoImageView2, phone: self.searchChattingList[indexPath.row].phoneList[1])
                     case "4":
                         cell.userImageView.isHidden = true
                         cell.userTwoImageView1.isHidden = true
                         cell.userTwoImageView2.isHidden = true
                         cell.userThreeImageView1.isHidden = false
                         cell.userThreeImageView2.isHidden = false
                         cell.userThreeImageView3.isHidden = false
                         cell.userFourImageView1.isHidden = true
                         cell.userFourImageView2.isHidden = true
                         cell.userFourImageView3.isHidden = true
                         cell.userFourImageView4.isHidden = true
                         self.findImage(imgView: cell.userThreeImageView1, phone: self.searchChattingList[indexPath.row].phoneList[0])
                         self.findImage(imgView: cell.userThreeImageView2, phone: self.searchChattingList[indexPath.row].phoneList[1])
                         self.findImage(imgView: cell.userThreeImageView3, phone: self.searchChattingList[indexPath.row].phoneList[2])
                     default:
                         cell.userImageView.isHidden = true
                         cell.userTwoImageView1.isHidden = true
                         cell.userTwoImageView2.isHidden = true
                         cell.userThreeImageView1.isHidden = true
                         cell.userThreeImageView2.isHidden = true
                         cell.userThreeImageView3.isHidden = true
                         cell.userFourImageView1.isHidden = false
                         cell.userFourImageView2.isHidden = false
                         cell.userFourImageView3.isHidden = false
                         cell.userFourImageView4.isHidden = false
                         self.findImage(imgView: cell.userFourImageView1, phone: self.searchChattingList[indexPath.row].phoneList[0])
                         self.findImage(imgView: cell.userFourImageView2, phone: self.searchChattingList[indexPath.row].phoneList[1])
                         self.findImage(imgView: cell.userFourImageView3, phone: self.searchChattingList[indexPath.row].phoneList[2])
                         self.findImage(imgView: cell.userFourImageView4, phone: self.searchChattingList[indexPath.row].phoneList[3])
                     }
                 }
             }
         }
         return cell
     }
     
    //테이블 뷰 섹션에 나타낼 로우 갯수
    func numberOfRowsInSection(section: Int, isFiltering: Bool) -> Int {
        if isFiltering == true {
            return self.searchChattingList.isEmpty ? 1 : self.searchChattingList.count
        } else {
            return self.chattingList.isEmpty ? 1 : self.chattingList.count
        }
    }
    
    func selectCell(uv: UIViewController, isFiltering: Bool, indexPath: IndexPath){
        guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "ChattingRoomVC") as? ChattingRoomVC else { return }
        
        //전달할 내용
        if isFiltering == false{
            if self.chattingList.isEmpty == false {
                //리스너 제거
                self.deleteListner()
                
                //변경할 내용
                self.chattingList[indexPath.row].presentUser.append(self.appDelegate.phoneInfo!)
                
                let newPresentUser = self.chattingList[indexPath.row].presentUser
                
                self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(self.chattingList[indexPath.row].dbID)").updateData([
                    "presentUser" : newPresentUser
                ])
                
                if self.chattingList[indexPath.row].activation == true {
                    for i in self.chattingList[indexPath.row].phoneList {
                        self.dbResultID = ""
                        self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                            if error == nil {
                                for doc in snapshot!.documents{
                                    self.dbResultID = doc.documentID
                                }
                                self.db.collection("users").document("\(self.dbResultID)").collection("chattingList").document("\(self.chattingList[indexPath.row].dbID)").updateData([
                                    "presentUser" : newPresentUser
                                ])
                            } else {
                                print(error!.localizedDescription)
                            }
                        }
                    }
                }
                
                //다음 화면에 보낼 내용
                nv.dbIDOnTable = self.chattingList[indexPath.row].dbID
                nv.phoneListOnTable = self.chattingList[indexPath.row].phoneList
                nv.roomTitleOnTable = self.chattingList[indexPath.row].roomTitle
                nv.activationOnTable = self.chattingList[indexPath.row].activation
                nv.reloadOnTable = false
                
                uv.navigationController?.pushViewController(nv, animated: true)
            }
        } else {
            if self.searchChattingList.isEmpty == false {
                //리스너 제거
                self.deleteListner()
                
                //변경할 내용
                self.searchChattingList[indexPath.row].presentUser.append(self.appDelegate.phoneInfo!)
                
                let newPresentUser = self.searchChattingList[indexPath.row].presentUser
                
                self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(self.searchChattingList[indexPath.row].dbID)").updateData([
                    "presentUser" : newPresentUser
                ])
                
                //TODO: 방이 활성화된 상태면 폰 리스트에 잇는 사람들의 presentUser 도 바꾸기
                
                if self.searchChattingList[indexPath.row].activation == true {
                    for i in self.searchChattingList[indexPath.row].phoneList {
                        self.dbResultID = ""
                        self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                            if error == nil {
                                for doc in snapshot!.documents{
                                    self.dbResultID = doc.documentID
                                }
                                self.db.collection("users").document("\(self.dbResultID)").collection("chattingList").document("\(self.searchChattingList[indexPath.row].dbID)").updateData([
                                    "presentUser" : newPresentUser
                                ])
                            } else {
                                print(error!.localizedDescription)
                            }
                        }
                    }
                }
                
                //다음 화면에 보낼 내용
                nv.dbIDOnTable = self.searchChattingList[indexPath.row].dbID
                nv.phoneListOnTable = self.searchChattingList[indexPath.row].phoneList
                nv.roomTitleOnTable = self.searchChattingList[indexPath.row].roomTitle
                nv.activationOnTable = self.searchChattingList[indexPath.row].activation
                nv.reloadOnTable = false
                
                //탭바 숨김
                let customTabBar = uv.tabBarController as! CSTabBarController
                customTabBar.csView.isHidden = true
                
                uv.navigationController?.pushViewController(nv, animated: true)
            }
        }
    }
    
    //MARK: 서치바 메소드
    func searchBarfilter(searchController: UISearchController, tableView: UITableView){
        guard let text = searchController.searchBar.text else { return }

        self.searchChattingList = self.chattingList.filter( { (list: ChattingModel) -> Bool in
            return list.roomTitle.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
    }
}
