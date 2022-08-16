//
//  ScheduleVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/03.
//

import FirebaseFirestore
import FirebaseStorage
import UIKit

class ScheduleVM {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var dbmyCompany: [String] = []              //내 회사
    var dbmyCompanyLogo: Bool = false           //회사 로고 유무
    
    //MARK: 회사 컬렉션 뷰
    //회사 찾기
    func findMyCompany(completion: @escaping([String]) -> ()) {
        self.dbmyCompany.removeAll()
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").getDocuments { (snapshot, error) in
            if error == nil {
                for doc in snapshot!.documents{
                    self.dbmyCompany.append(doc.documentID)
                }
                completion(self.dbmyCompany)
                
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
