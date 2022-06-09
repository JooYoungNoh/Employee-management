//
//  ProfileVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/10.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ProfileVM {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var dbmyCompany: [String] = []
    
    func findMyCompany(completion: @escaping([String]) -> ()) {
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
}
