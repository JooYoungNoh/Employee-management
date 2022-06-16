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
     
    func findProfileImage(phoneOnTable: String, imageChooseOnTable: Bool, profileView: UIImageView){
        if imageChooseOnTable == true {
            storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/\(phoneOnTable)").downloadURL { (url, error) in
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
}
