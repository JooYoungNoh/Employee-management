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
    
    //MARK: 액션 메소드
    func goNotice(uv: UIViewController, companyNameOnTable: String){
        let nv = uv.storyboard?.instantiateViewController(withIdentifier: "naviNotice")
        nv!.modalPresentationStyle = .fullScreen
        self.appDelegate.schedulePartCompanyName = companyNameOnTable
        uv.present(nv!, animated: true)
    }
    
    //MARK: 테이블 뷰 메소드
    
    //MARK: FS캘린더 메소드
    func goTimetable(){
        
    }
    
}
