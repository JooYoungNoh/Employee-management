//
//  EmployeeListVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/03.
//

import UIKit
import FirebaseFirestore

class EmployeeListVM {
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var myCompany: [String] = []
    var employeeList: [EmployeeModel] = []
    var employeeResult: [EmployeeModel] = []
    
    //내가 속한 회사 정보 불러오기
    func findCompany(completion: @escaping([String]) ->() ){
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").getDocuments { (snapshot, error) in
            for doc in snapshot!.documents{
                
                self.myCompany.append(doc.documentID)
            }
            completion(self.myCompany)
        }
    }
    
    //내가 속한 회사 직원 리스트 불러오기
    func findEmployList(completion2: @escaping([EmployeeModel]) -> () ){
        
        self.findCompany{ completion in
            for i in completion {
                self.db.collection("shop").document("\(i)").collection("employeeControl").getDocuments{ snapshot2, error in
                    for doc2 in snapshot2!.documents{
                        self.employeeList.append( EmployeeModel.init(name: doc2.data()["name"] as! String, phone: doc2.data()["phone"] as! String, comment: doc2.data()["comment"] as! String))
                    }
                    
                    //내 정보 지우기(직원리스트)
                    self.employeeList.removeAll(where: {$0.phone == "\(self.appDelegate.phoneInfo!)"})
                    
                    
                    
                    completion2(self.employeeList)
                }
            }
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        return self.employeeList.count
    }
    
}
