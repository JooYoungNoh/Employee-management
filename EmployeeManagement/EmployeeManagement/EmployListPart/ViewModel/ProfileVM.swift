//
//  ProfileVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/17.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class ProfileVM {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var dbmyCompany: [String] = []              //내 회사
    var dbEmployeeCompany: [String] = []        //동료 회사
    var sortedCompany: [String] = []
    var dbmyCompanyLogo: Bool = false           //회사 로고 유무
     
    func findProfileImage(phoneOnTable: String, imageChooseOnTable: Bool, profileView: UIImageView){
        if imageChooseOnTable == true {
            storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/userprofile/\(phoneOnTable)").downloadURL { (url, error) in
                if error == nil && url != nil {
                    let data = NSData(contentsOf: url!)
                    let dbImage = UIImage(data: data! as Data)
                    
                    profileView.image = dbImage!
                } else {
                    print(error!.localizedDescription)
                }
            }
        } else {
            profileView.image = UIImage(named: "account")
        }
    }
    

    //MARK: 회사 컬렉션 뷰   나랑 같은 회사인 것 가져오기
    //회사 찾기
    func findMyCompany(phoneOnTable: String , completion: @escaping([String]) -> ()) {
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").getDocuments { (snapshot, error) in
            if error == nil {
                for doc in snapshot!.documents{
                    self.dbmyCompany.append(doc.documentID)
                }
                for dic in self.dbmyCompany{
                    self.db.collection("shop").document("\(dic)").collection("employeeControl").whereField("phone", isEqualTo: "\(phoneOnTable)").getDocuments { (snapshot2, error2) in
                        for doc2 in snapshot2!.documents{
                            if doc2.documentID.isEmpty == false {
                                self.dbEmployeeCompany.append(dic)
                                print("이거지 : \(self.dbEmployeeCompany)")
                            }
                        }
                            self.sortedCompany = self.dbEmployeeCompany.sorted(by: {$0 < $1})
                            completion(self.sortedCompany)
                        
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //회사 이미지 다운로드
    func companyDownloadimage(imgView: UIImageView, company: String){
        self.db.collection("shop").document("\(company)").getDocument { snapshot, error in
            self.dbmyCompanyLogo = snapshot!.data()!["img"] as! Bool
            
            if self.dbmyCompanyLogo == true{
                self.storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/logoimage/\(company)").downloadURL { (url, error) in
                    if error == nil && url != nil {
                        let data = NSData(contentsOf: url!)
                        let dbImage = UIImage(data: data! as Data)
                        
                        imgView.image = dbImage
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            } else {
                imgView.image = UIImage(named: "logonil")
            }
        }
    }
}
