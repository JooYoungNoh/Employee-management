//
//  ChattingInviteVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/09/21.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SnapKit
import UIKit

class ChattingInviteVM {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let semaphore = DispatchSemaphore(value: 0)
    let group = DispatchGroup()
    
    //컬랙션 뷰
    var collectionList: [Int] = []
    var collectionInfoList: [collectionListInviteModel] = []
    
    //컬랙션 뷰 높이
    var changeHeight: Int = 0
    var heightConstraint: Constraint? = nil
    
    // 테이블 뷰
    var myCompany: [String] = []
    var employeeList: [ChattingInviteModel] = []          //디비에서 값 받아옴
    var employeeResult: [ChattingInviteModel] = []        //Set로 중복값 제거
    var employeeRealResult: [ChattingInviteModel] = []    //정렬된 값
    
    //현재 인원 저장 변수
    var chatPresentUser: [String] = []
    
    //초대된 사람 저장 변수
    var dbPhone: [String] = []
    var dbRoom: String = ""
    var dbcheck: String = ""
    var dbNewPhone: [String] = []
    
    //내 저장 변수
    var myPhone: [String] = []
    var myNewPhone: [String] = []
    
    //기존 유저 변수(나 빼고)
    var existCheck: String = ""
    var existPhone: [String] = []
    var existNewPhone: [String] = []
    
    
    //MARK: 액션 메소드
    //내가 속한 회사 정보 불러오기
    func findCompany(completion: @escaping([String]) ->() ){
        //최종 직원 리스트 결과 초기화
        self.employeeResult.removeAll()
        
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").getDocuments { (snapshot, error) in
            //회사 이름 배열 초기화
            self.myCompany.removeAll()
            //DB에서 정보 가져오기
            for doc in snapshot!.documents{
                self.myCompany.append(doc.documentID)
            }
            completion(self.myCompany)  // == return
        }
    }
    
    //내가 속한 회사 직원 리스트 불러오기
    func findEmployList(phoneListOnTable: [String], completion2: @escaping([ChattingInviteModel]) -> () ){
        //구조체 배열 초기화
        self.employeeList.removeAll()
        self.collectionList.removeAll()
        self.collectionInfoList.removeAll()
      
        self.findCompany{ completion in
            for i in completion {
                self.db.collection("shop").document("\(i)").collection("employeeControl").getDocuments{ snapshot2, error in
                    
                    //DB에서 정보 가져오기
                    for doc2 in snapshot2!.documents{
                        self.employeeList.append( ChattingInviteModel.init(name: doc2.data()["name"] as! String, phone: doc2.data()["phone"] as! String, comment: doc2.data()["comment"] as! String, id: doc2.data()["id"] as! String, profileImg: doc2.data()["profileImg"] as! Bool))
                    }
                    
                    let hash = (Set(self.employeeList))
                    
                    self.employeeResult = Array(hash)
                    
                    //내 정보 지우기(직원리스트)
                    self.employeeResult.removeAll(where: {$0.phone == "\(self.appDelegate.phoneInfo!)"})
                    
                    //현재 방에 있는 인원 정보 지우기
                    for i in phoneListOnTable {
                        self.employeeResult.removeAll(where: {$0.phone == "\(i)"})
                    }
                    
                    self.employeeRealResult = self.employeeResult.sorted(by: {$0.name < $1.name})
                    
                    completion2(self.employeeRealResult)    // == return
                }
            }
        }
    }
    
    //이미지 다운
    func employeeDownloadimage(imgView: UIImageView, phone: String){
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
    
    //저장 버튼
    func dosave(uv: UIViewController, phoneListOnTable: [String], roomTitleOnTable: String, dbIDOnTable: String) {
        let alert = UIAlertController(title: "초대하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
            let date = Date().timeIntervalSince1970
            self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").getDocument { snapshot3, error3 in
                if error3 == nil {
                    self.chatPresentUser.removeAll()
                    self.chatPresentUser = (snapshot3!.data()!["presentUser"] as! [String])
                    
                    //초대된 사람에게 방의 기본 정보 추가
                    DispatchQueue.global().async {
                        for i in self.collectionInfoList {
                            self.group.enter()
                            self.db.collection("users").whereField("phone", isEqualTo: i.phone).getDocuments { snapshot, error in
                                if error == nil {
                                    self.dbcheck = ""
                                    self.dbPhone.removeAll()
                                    self.dbNewPhone.removeAll()
                                    for doc in snapshot!.documents{
                                        self.dbcheck = doc.documentID
                                    }
                                    self.dbPhone = phoneListOnTable
                                    self.dbNewPhone.removeAll()
                                    for y in self.collectionInfoList {
                                        if y.phone == i.phone {
                                            self.dbNewPhone.append("\(self.appDelegate.phoneInfo!)")
                                        } else {
                                            self.dbNewPhone.append(y.phone)
                                        }
                                    }
                                    self.dbPhone.append(contentsOf: self.dbNewPhone)
                                    
                                    self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").setData([
                                        "date" : date,
                                        "roomTitle" : roomTitleOnTable,
                                        "phoneList" : self.dbPhone,
                                        "memberCount" : "\(self.dbPhone.count + 1)",
                                        "newMessage" : "",
                                        "newCount" : "0",
                                        "activation" : true,
                                        "presentUser" : self.chatPresentUser,
                                        "type" : "multi"
                                    ])
                                    //메시지 보내기
                                    self.db.collection("users").document("\(self.dbcheck)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                                        "checkRead" : true,
                                        "imgCheck" : false,
                                        "date" : date,
                                        "sender" : "invitation",
                                        "message" : self.collectionInfoList.count == 1 ? "\(i.name)님이 초대되었습니다" : "\(i.name)님외 \(self.collectionInfoList.count - 1)명이 초대되었습니다",
                                        "readList" : self.chatPresentUser,
                                        "userCount" : "\(self.dbPhone.count + 1)"
                                    ]) { (_) in
                                        self.semaphore.signal()
                                        self.group.leave()
                                    }
                                }
                            }
                            self.semaphore.wait()
                        }
                        self.group.notify(queue: DispatchQueue.main) {
                             print("끝")
                        }
                    }
                    
                    DispatchQueue.global().async {
                        //내 정보 바꾸기
                        self.myPhone = phoneListOnTable
                        for i in self.collectionInfoList{
                            self.myNewPhone.append(i.phone)
                        }
                        self.myPhone.append(contentsOf: self.myNewPhone)
                        
                        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                            "memberCount" : "\(self.myPhone.count + 1)",
                            "phoneList" : self.myPhone,
                            "type" : "multi"
                        ])
                        
                        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                            "checkRead" : true,
                            "imgCheck" : false,
                            "date" : date,
                            "sender" : "invitation",
                            "message" : self.collectionInfoList.count == 1 ? "\(self.collectionInfoList[0].name)님이 초대되었습니다" : "\(self.collectionInfoList[0].name)님외 \(self.collectionInfoList.count - 1)명이 초대되었습니다",
                            "readList" : self.chatPresentUser,
                            "userCount" : "\(self.myPhone.count + 1)"
                        ])
                    }
                    
                    DispatchQueue.global().async {
                        //기존 유저 정보 바꾸기
                        for i in phoneListOnTable {
                            self.group.enter()
                            self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                                if error == nil {
                                    self.existCheck = ""
                                    self.existPhone.removeAll()
                                    self.existNewPhone.removeAll()
                                    for doc in snapshot!.documents{
                                        self.existCheck = doc.documentID
                                    }
                                    self.existPhone = phoneListOnTable
                                    
                                    if let index = self.existPhone.firstIndex(of: i){
                                        self.existPhone.remove(at: index)
                                        self.existPhone.append(self.appDelegate.phoneInfo!)
                                    }
                                    
                                    for i in self.collectionInfoList{
                                        self.existNewPhone.append(i.phone)
                                    }
                                    self.existPhone.append(contentsOf: self.existNewPhone)
                                    
                                    self.db.collection("users").document("\(self.existCheck)").collection("chattingList").document("\(dbIDOnTable)").updateData([
                                        "memberCount" : "\(self.existPhone.count + 1)",
                                        "phoneList" : self.existPhone,
                                        "type" : "multi"
                                    ])
                                    //메시지 보내기
                                    self.db.collection("users").document("\(self.existCheck)").collection("chattingList").document("\(dbIDOnTable)").collection("chat").addDocument(data: [
                                        "checkRead" : true,
                                        "imgCheck" : false,
                                        "date" : date,
                                        "sender" : "invitation",
                                        "message" : self.collectionInfoList.count == 1 ? "\(self.collectionInfoList[0].name)님이 초대되었습니다" : "\(self.collectionInfoList[0].name)외 \(self.collectionInfoList.count - 1)명이 초대되었습니다",
                                        "readList" : self.chatPresentUser,
                                        "userCount" : "\(self.existPhone.count + 1)"
                                    ]) { (_) in
                                        self.semaphore.signal()
                                        self.group.leave()
                                    }
                                }
                            }
                            self.semaphore.wait()
                        }
                        self.group.notify(queue: DispatchQueue.main) {
                             print("끝")
                        }
                    }
                    uv.dismiss(animated: true)
                } else {
                    print(error3!.localizedDescription)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        uv.present(alert, animated: true)
    }
    
    //MARK: 테이블 뷰 메소드
    func cellInfoTable(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingInviteCell", for: indexPath) as? ChattingInviteCell else { return UITableViewCell() }
        
        //이름
        cell.nameLabel.text = self.employeeRealResult[indexPath.row].name
        
        //프로필 이미지
        if self.employeeRealResult[indexPath.row].profileImg == true {
            self.employeeDownloadimage(imgView: cell.userImageView, phone: self.employeeRealResult[indexPath.row].phone)
        } else {
            cell.userImageView.image = UIImage(named: "account")
        }
        
        //체크 표시
        if self.collectionList.contains(indexPath.row) == true {
            cell.checkImageView.isHidden = false
        } else {
            cell.checkImageView.isHidden = true
        }
        return cell
    }
    
    func selectCellTable(tableView: UITableView, indexPath: IndexPath, uv: UIViewController, saveButton: UIButton, collectionView: UICollectionView) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell  = tableView.cellForRow(at: indexPath) as! ChattingInviteCell
        
        if cell.checkImageView.isHidden == true {
            cell.checkImageView.isHidden = false
            self.collectionList.append(indexPath.row)
            self.collectionInfoList.append(collectionListInviteModel.init(name: cell.nameLabel.text!, phone: self.employeeRealResult[indexPath.row].phone, image: cell.userImageView.image!))
            
            if self.changeHeight == 0 {
                self.changeHeight = 70
                self.heightConstraint?.update(offset: self.changeHeight)
                
                UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                    uv.view.layoutIfNeeded()
                }).startAnimation()
            }
            saveButton.isHidden = false
        } else {
            cell.checkImageView.isHidden = true
            if let index = self.collectionList.firstIndex(of: indexPath.row){
                self.collectionList.remove(at: index)
                self.collectionInfoList.remove(at: index)
                
                if self.collectionList.isEmpty == true {
                    self.changeHeight = 0
                    self.heightConstraint?.update(offset: self.changeHeight)
                    
                    UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                        uv.view.layoutIfNeeded()
                    }).startAnimation()
                    saveButton.isHidden = true
                }
            }
        }
        collectionView.reloadData()
    }
    
    //MARK: 컬랙션 뷰 메소드
    func cellInfoCollection(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingInviteCVCell.identifier, for: indexPath) as? ChattingInviteCVCell else { return UICollectionViewCell() }
    
        if self.collectionList.count != 0 {
            cell.nameLabel.text = self.collectionInfoList[indexPath.row].name
            cell.imageView.image = self.collectionInfoList[indexPath.row].image
        }
        
        return cell
    }
}
