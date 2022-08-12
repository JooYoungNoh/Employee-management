//
//  TimetableVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/09.
//

import Foundation
import UIKit
import FirebaseFirestore

class TimetableVM {
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK: 액션 메소드
    func addTimetable(uv: UIViewController, companyOnTable: String, dateOnTable: String){
        if self.appDelegate.jobInfo == "2" {
            let alert = UIAlertController(title: nil, message: "직원 이상의 직책만 사용가능합니다", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            uv.present(alert, animated: true)
        } else {
            guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "TimetableCreateVC") as? TimetableCreateVC else { return }
            nv.modalPresentationStyle = .fullScreen
            nv.companyOnTable = companyOnTable
            nv.dateOnTable = dateOnTable
            
            uv.present(nv, animated: true)
        }
    }
}
