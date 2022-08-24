//
//  ChattingVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/18.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ChattingVM {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var listner: ListenerRegistration?              //리스너 삭제
    
    var chattingList: [ChattingModel] = []
    var sortChattingList: [ChattingModel] = []
    var searchChattingList: [ChattingModel] = []
    
    var userProfileImgCheck: Bool = false
    
    //MARK: 액션 메소드
    //채팅방 리스트 불러오기
    func bringChattingList(completion: @escaping([ChattingModel]) -> () ){
        //구조체 배열 초기화
        self.chattingList.removeAll()
        self.sortChattingList.removeAll()
        self.searchChattingList.removeAll()
        self.listner = self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").addSnapshotListener { (snapShot, error) in
            if error == nil && snapShot != nil{
                for doc in snapShot!.documents{
                    self.chattingList.append(ChattingModel.init(activation: doc.data()["activation"] as! Bool, date: doc.data()["date"] as! TimeInterval, memberCount: doc.data()["memberCount"] as! String, newCount: doc.data()["newCount"] as! String, newMessage: doc.data()["newMessage"] as! String, roomTitle: doc.data()["roomTitle"] as! String, phoneList: doc.data()["phoneList"] as! [String]))
                }
                self.sortChattingList = self.chattingList.sorted(by: {$0.date > $1.date})
                completion(self.sortChattingList)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func profileDownloadimage(imgView: UIImageView, phone: String){
        self.db.collection("users").whereField("phone", isEqualTo: phone).getDocuments { snapShot, error in
            if error == nil {
                for doc in snapShot!.documents{
                    self.userProfileImgCheck = doc.data()["profileImg"] as! Bool
                }
                if self.userProfileImgCheck == false {
                    imgView.image = UIImage(named: "account")
                } else {
                    self.storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/userprofile/\(phone)").downloadURL { (url, error) in
                        if error == nil && url != nil {
                            let data = NSData(contentsOf: url!)
                            let dbImage = UIImage(data: data! as Data)
                            
                            imgView.image = dbImage
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
         if isFiltering == false {
             if self.sortChattingList.isEmpty == true {
                 cell.titleLabel.text = "채팅방이 없습니다."
                 cell.titleLabel.textColor = .red
                 cell.commentLabel.text = "생성해주세여~"
                 cell.commentLabel.textColor = .red
                 cell.dateLabel.text = ""
                 cell.userCount.text = ""
             } else {
                 let date = Date(timeIntervalSince1970: self.sortChattingList[indexPath.row].date) + 32400
                 
                 let formatter = DateFormatter()
                 formatter.dateFormat = "yyyy-MM-dd"
                 formatter.timeZone = TimeZone(identifier: "UTC")
                 let fixDate = "\(formatter.string(from: date))"
                 
                 //방 제목
                 cell.titleLabel.text = self.sortChattingList[indexPath.row].roomTitle
                 cell.titleLabel.textColor = .black
                 
                 //방 업데이트 날짜
                 cell.dateLabel.text = fixDate
                 
                 //메시지
                 if self.sortChattingList[indexPath.row].activation == false {
                     cell.commentLabel.text = "채팅을 입력하여 방을 활성화해주세요"
                 } else {
                     cell.commentLabel.text = self.sortChattingList[indexPath.row].newMessage
                 }
                 cell.commentLabel.textColor = .black
                 
                 //방 프로필 이미지
                 DispatchQueue.main.async {
                     switch self.sortChattingList[indexPath.row].memberCount {
                     case "2":
                         cell.userImageView.isHidden = false
                         self.profileDownloadimage(imgView: cell.userImageView, phone: self.sortChattingList[indexPath.row].phoneList[0])
                     case "3":
                         cell.userTwoImageView1.isHidden = false
                         cell.userTwoImageView2.isHidden = false
                         self.profileDownloadimage(imgView: cell.userTwoImageView1, phone: self.sortChattingList[indexPath.row].phoneList[0])
                         self.profileDownloadimage(imgView: cell.userTwoImageView2, phone: self.sortChattingList[indexPath.row].phoneList[1])
                     case "4":
                         cell.userThreeImageView1.isHidden = false
                         cell.userThreeImageView2.isHidden = false
                         cell.userThreeImageView3.isHidden = false
                         self.profileDownloadimage(imgView: cell.userThreeImageView1, phone: self.sortChattingList[indexPath.row].phoneList[0])
                         self.profileDownloadimage(imgView: cell.userThreeImageView2, phone: self.sortChattingList[indexPath.row].phoneList[1])
                         self.profileDownloadimage(imgView: cell.userThreeImageView3, phone: self.sortChattingList[indexPath.row].phoneList[2])
                     default:
                         cell.userFourImageView1.isHidden = false
                         cell.userFourImageView2.isHidden = false
                         cell.userFourImageView3.isHidden = false
                         cell.userFourImageView4.isHidden = false
                         self.profileDownloadimage(imgView: cell.userFourImageView1, phone: self.sortChattingList[indexPath.row].phoneList[0])
                         self.profileDownloadimage(imgView: cell.userFourImageView2, phone: self.sortChattingList[indexPath.row].phoneList[1])
                         self.profileDownloadimage(imgView: cell.userFourImageView3, phone: self.sortChattingList[indexPath.row].phoneList[2])
                         self.profileDownloadimage(imgView: cell.userFourImageView4, phone: self.sortChattingList[indexPath.row].phoneList[3])
                     }

                 }
             }
         } else {
             if self.searchChattingList.isEmpty == true {
                 cell.titleLabel.text = "검색 결과가 없습니다"
                 cell.titleLabel.textColor = .red
                 cell.dateLabel.text = ""
             } else {
                 let date2 = Date(timeIntervalSince1970: self.searchChattingList[indexPath.row].date) + 32400
                 let formatter = DateFormatter()
                 formatter.dateFormat = "yyyy-MM-dd"
                 formatter.timeZone = TimeZone(identifier: "UTC")
                 
                 let fixDate2 = "\(formatter.string(from: date2))"
                 
                 //방 제목
                 cell.titleLabel.text = self.searchChattingList[indexPath.row].roomTitle
                 cell.titleLabel.textColor = .black
                 //방 업데이트 날짜
                 cell.dateLabel.text = fixDate2
                 
                 //메시지
                 if self.searchChattingList[indexPath.row].activation == false {
                     cell.commentLabel.text = "채팅을 입력하여 방을 활성화해주세요"
                 } else {
                     cell.commentLabel.text = self.searchChattingList[indexPath.row].newMessage
                 }
                 cell.commentLabel.textColor = .black
                 
                 //방 프로필 이미지
                 DispatchQueue.main.async {
                     switch self.searchChattingList[indexPath.row].memberCount {
                     case "2":
                         cell.userImageView.isHidden = false
                         self.profileDownloadimage(imgView: cell.userImageView, phone: self.searchChattingList[indexPath.row].phoneList[0])
                     case "3":
                         cell.userTwoImageView1.isHidden = false
                         cell.userTwoImageView2.isHidden = false
                         self.profileDownloadimage(imgView: cell.userTwoImageView1, phone: self.searchChattingList[indexPath.row].phoneList[0])
                         self.profileDownloadimage(imgView: cell.userTwoImageView2, phone: self.searchChattingList[indexPath.row].phoneList[1])
                     case "4":
                         cell.userThreeImageView1.isHidden = false
                         cell.userThreeImageView2.isHidden = false
                         cell.userThreeImageView3.isHidden = false
                         self.profileDownloadimage(imgView: cell.userThreeImageView1, phone: self.searchChattingList[indexPath.row].phoneList[0])
                         self.profileDownloadimage(imgView: cell.userThreeImageView2, phone: self.searchChattingList[indexPath.row].phoneList[1])
                         self.profileDownloadimage(imgView: cell.userThreeImageView3, phone: self.searchChattingList[indexPath.row].phoneList[2])
                     default:
                         cell.userFourImageView1.isHidden = false
                         cell.userFourImageView2.isHidden = false
                         cell.userFourImageView3.isHidden = false
                         cell.userFourImageView4.isHidden = false
                         self.profileDownloadimage(imgView: cell.userFourImageView1, phone: self.searchChattingList[indexPath.row].phoneList[0])
                         self.profileDownloadimage(imgView: cell.userFourImageView2, phone: self.searchChattingList[indexPath.row].phoneList[1])
                         self.profileDownloadimage(imgView: cell.userFourImageView3, phone: self.searchChattingList[indexPath.row].phoneList[2])
                         self.profileDownloadimage(imgView: cell.userFourImageView4, phone: self.searchChattingList[indexPath.row].phoneList[3])
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
            return self.sortChattingList.isEmpty ? 1 : self.sortChattingList.count
        }
    }
    
    /*func selectCell(uv: UIViewController, isFiltering: Bool, indexPath: IndexPath){
        guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "MemoReadVC") as? MemoReadVC else { return }
        
        //전달할 내용
        if isFiltering == false{
            if self.realMemoList.isEmpty == false {
                nv.titleOnTable = self.realMemoList[indexPath.row].title
                nv.dateOnTable = self.realMemoList[indexPath.row].date
                nv.textOnTable = self.realMemoList[indexPath.row].text
                nv.countOnTable = self.realMemoList[indexPath.row].count
                
                uv.navigationController?.pushViewController(nv, animated: true)
            }
        } else {
            if self.searchMemoList.isEmpty == false {
                nv.titleOnTable = self.searchMemoList[indexPath.row].title
                nv.dateOnTable = self.searchMemoList[indexPath.row].date
                nv.textOnTable = self.searchMemoList[indexPath.row].text
                nv.countOnTable = self.searchMemoList[indexPath.row].count
                
                uv.navigationController?.pushViewController(nv, animated: true)
            }
        }
    }*/
    
    //MARK: 서치바 메소드
    func searchBarfilter(searchController: UISearchController, tableView: UITableView){
        guard let text = searchController.searchBar.text else { return }

        self.searchChattingList = self.sortChattingList.filter( { (list: ChattingModel) -> Bool in
            return list.roomTitle.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
    }
}
