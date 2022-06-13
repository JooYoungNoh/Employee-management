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
    
    //MARK: section 0
    //내 정보 가져오기
    func findMe(completion: @escaping() -> () ){
        self.myName = self.appDelegate.nameInfo!
        self.myPhone = self.appDelegate.phoneInfo!
        
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").getDocument { (snapshot, error) in
            self.myComment = snapshot!.data()!["comment"] as! String
            self.myProfileImg = snapshot!.data()!["profileImg"] as! Bool
            
            //로그인 후 첫 화면 이므로 가입요청할 때 넣기위해 프로필 상태 가져옴
   
            completion()
        }
        
    }
    
    //MARK: section 1
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
    func findEmployList(completion2: @escaping([EmployeeModel]) -> () ){
        //구조체 배열 초기화
        self.employeeList.removeAll()
      
        //"phone" 배열들 초기화
        self.employeePhoneList.removeAll()
        self.employeePhoneResult.removeAll()
        self.findCompany{ completion in
            for i in completion {
                self.db.collection("shop").document("\(i)").collection("employeeControl").getDocuments{ snapshot2, error in
                    
                    //DB에서 정보 가져오기
                    for doc2 in snapshot2!.documents{
                        self.employeeList.append( EmployeeModel.init(name: doc2.data()["name"] as! String, phone: doc2.data()["phone"] as! String, comment: doc2.data()["comment"] as! String, profileImg: doc2.data()["profileImg"] as! Bool))
                        self.employeePhoneList.append(doc2.data()["phone"] as! String)
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
    
    //MARK: 이미지 있을 떄 다운로드 메소드
    //TODO: 나중에 png 빼기
    func myDownloadimage(choose: Bool) -> UIImage{
        
        if choose == true {
            storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/\(self.appDelegate.phoneInfo!)").downloadURL { [self] (url, error) in
                if error == nil && url != nil {
                    let data = NSData(contentsOf: url!)
                    let dbImage = UIImage(data: data! as Data)
                    
                    self.myImage = dbImage!
                } else {
                    print(error!.localizedDescription)
                }
            }
        } else {
            self.myImage = UIImage(named: "account")
        }
        return self.myImage!
    }
    
    func employeeDownloadimage(imgView: UIImageView, phone: String){
        storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/\(phone)").downloadURL { (url, error) in
            if error == nil && url != nil {
                let data = NSData(contentsOf: url!)
                let dbImage = UIImage(data: data! as Data)
                
                imgView.image = dbImage
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    
    //테이블 뷰 섹션에 나타낼 로우 갯수
    func numberOfRowsInSection(section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            return self.employeeRealResult.count
        }
    }
}
