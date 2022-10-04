//
//  EmployeeListVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/03.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class EmployeeListVM {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //section 0
    var myName: String = ""
    var myComment: String = ""
    var myProfileImg: Bool = false
    var myPhone: String = ""
    var myImage: UIImage!
    
    
    //section 1
    var myCompany: [String] = []
    var employeeList: [EmployeeModel] = []          //디비에서 값 받아옴
    var employeeResult: [EmployeeModel] = []        //Set로 중복값 제거
    var employeeRealResult: [EmployeeModel] = []    //정렬된 값
    var employeePhoneList: [String] = []
    var employeePhoneResult: [String] = []
    var searchResult: [EmployeeModel] = []
    
    var userImageList: [imageSave] = []
    
    
    
    //MARK: 리스트 불러오기
    func findList(completion2: @escaping([EmployeeModel]) -> () ){
        //구조체 배열 초기화
        self.employeeList.removeAll()
        self.userImageList.removeAll()
      
        //"phone" 배열들 초기화
        self.employeePhoneList.removeAll()
        self.employeePhoneResult.removeAll()
        self.employeeResult.removeAll()
        
        //내 정보 초기화
        self.myName = self.appDelegate.nameInfo!
        self.myPhone = self.appDelegate.phoneInfo!
        
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").getDocument { (snapshot, error) in
            self.myComment = snapshot!.data()!["comment"] as! String
            self.myProfileImg = snapshot!.data()!["profileImg"] as! Bool
            
            self.profileDownloadimage(phone: self.myPhone, imgCheck: self.myProfileImg)
            
            self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").getDocuments { (snapshot, error) in
                //회사 이름 배열 초기화
                self.myCompany.removeAll()
                //DB에서 정보 가져오기
                for doc in snapshot!.documents{
                    self.myCompany.append(doc.documentID)
                }
                for i in self.myCompany {
                    self.db.collection("shop").document("\(i)").collection("employeeControl").getDocuments{ snapshot2, error in
                        
                        //DB에서 정보 가져오기
                        for doc2 in snapshot2!.documents{
                            self.employeeList.append( EmployeeModel.init(name: doc2.data()["name"] as! String, phone: doc2.data()["phone"] as! String, comment: doc2.data()["comment"] as! String, id: doc2.data()["id"] as! String, profileImg: doc2.data()["profileImg"] as! Bool))
                            self.employeePhoneList.append(doc2.data()["phone"] as! String)
                        }
                        
                        let hash = (Set(self.employeeList))
                        
                        self.employeeResult = Array(hash)
                        
                        //내 정보 지우기(직원리스트)
                        self.employeeResult.removeAll(where: {$0.phone == "\(self.appDelegate.phoneInfo!)"})
                        
                        self.employeeRealResult = self.employeeResult.sorted(by: {$0.name < $1.name})
                        
                        
                        for y in self.employeeResult {
                            self.profileDownloadimage(phone: y.phone, imgCheck: y.profileImg)
                        }
                        
                        if i == self.myCompany.last {
                            completion2(self.employeeRealResult)    // == return
                        }
                    }
                }
            }
            
        }
    }
    
    //MARK: 이미지 다운로드 메소드
    func profileDownloadimage(phone: String, imgCheck: Bool){
        if imgCheck == false {
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
    }
    
    //전화변호로 이미지 찾기
    func findImage(imgView: UIImageView, phone: String){
        if let index = self.userImageList.firstIndex(where: {$0.userPhone == phone}){
            imgView.image = self.userImageList[index].userImage
        }
    }
    
    //MARK: 로그아웃
    func doLogout(vc: UIViewController){
        let alert = UIAlertController(title: "선택해주세요", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "로그아웃", style: .default) { (_) in
            let firstScreen = vc.storyboard?.instantiateViewController(withIdentifier: "first")
            firstScreen?.modalTransitionStyle = .crossDissolve
            firstScreen?.modalPresentationStyle = .fullScreen
            vc.present(firstScreen!, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.present(alert, animated: true)
    }
    
    func searchBarfilter(searchController: UISearchController, tableView: UITableView){
        guard let text = searchController.searchBar.text else { return }

        self.searchResult = self.employeeRealResult.filter( { (list: EmployeeModel) -> Bool in
            return list.name.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
    }
    
    //테이블 뷰 섹션에 나타낼 로우 갯수
    func numberOfRowsInSection(section: Int, isFiltering: Bool) -> Int {
        return isFiltering ? self.searchResult.count : self.employeeRealResult.count
    }
}
