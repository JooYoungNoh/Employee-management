//
//  CreateChatVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/21.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class CreateChatVM {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //컬랙션 뷰
    var collectionList: [Int] = []
    
    // 테이블 뷰
    var myCompany: [String] = []
    var employeeList: [CreateChatModel] = []          //디비에서 값 받아옴
    var employeeResult: [CreateChatModel] = []        //Set로 중복값 제거
    var employeeRealResult: [CreateChatModel] = []    //정렬된 값
    
    
    //MARK: 테이블 뷰 메소드
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
    
}
