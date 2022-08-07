//
//  CalendarVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/04.
//

import FirebaseFirestore

class CalendarVM {
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var checkSchedule: [Int] = []
    
    func goNotice(uv: UIViewController, companyNameOnTable: String){
        let nv = uv.storyboard?.instantiateViewController(withIdentifier: "naviNotice")
        nv!.modalPresentationStyle = .fullScreen
        self.appDelegate.schedulePartCompanyName = companyNameOnTable
        uv.present(nv!, animated: true)
    }
}
