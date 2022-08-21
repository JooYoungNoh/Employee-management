//
//  CreateChatVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import SnapKit

class CreateChatVM {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //컬랙션 뷰
    var collectionList: [Int] = []
    var collectionInfoList: [collectionListModel] = []
    
    //컬랙션 뷰 높이
    var changeHeight: Int = 0
    var heightConstraint: Constraint? = nil
    
    // 테이블 뷰
    var myCompany: [String] = []
    var employeeList: [CreateChatModel] = []          //디비에서 값 받아옴
    var employeeResult: [CreateChatModel] = []        //Set로 중복값 제거
    var employeeRealResult: [CreateChatModel] = []    //정렬된 값
    
    
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
    func findEmployList(completion2: @escaping([CreateChatModel]) -> () ){
        //구조체 배열 초기화
        self.employeeList.removeAll()
        self.collectionList.removeAll()
        self.collectionInfoList.removeAll()
      
        self.findCompany{ completion in
            for i in completion {
                self.db.collection("shop").document("\(i)").collection("employeeControl").getDocuments{ snapshot2, error in
                    
                    //DB에서 정보 가져오기
                    for doc2 in snapshot2!.documents{
                        self.employeeList.append( CreateChatModel.init(name: doc2.data()["name"] as! String, phone: doc2.data()["phone"] as! String, comment: doc2.data()["comment"] as! String, id: doc2.data()["id"] as! String, profileImg: doc2.data()["profileImg"] as! Bool))
                    }
                    
                    let hash = (Set(self.employeeList))
                    
                    self.employeeResult = Array(hash)
                    
                    //내 정보 지우기(직원리스트)
                    self.employeeResult.removeAll(where: {$0.phone == "\(self.appDelegate.phoneInfo!)"})
                    
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
    
    //MARK: 테이블 뷰 메소드
    func cellInfoTable(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreateChatCell", for: indexPath) as? CreateChatCell else { return UITableViewCell() }
        
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
        let cell  = tableView.cellForRow(at: indexPath) as! CreateChatCell
        
        if cell.checkImageView.isHidden == true {
            cell.checkImageView.isHidden = false
            self.collectionList.append(indexPath.row)
            self.collectionInfoList.append(collectionListModel.init(name: cell.nameLabel.text!, phone: self.employeeRealResult[indexPath.row].phone, image: cell.userImageView.image!))
            
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateChatCVCell.identifier, for: indexPath) as? CreateChatCVCell else { return UICollectionViewCell() }
    
        if self.collectionList.count != 0 {
            cell.nameLabel.text = self.collectionInfoList[indexPath.row].name
            cell.imageView.image = self.collectionInfoList[indexPath.row].image
        }
        
        return cell
    }
    
}
