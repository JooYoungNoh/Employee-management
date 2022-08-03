//
//  CalendarVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/04.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarVC: UIViewController {
    
    var companyNameOnTable: String = ""
    
    let companyCalendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.appearance.titleFont = UIFont(name: "CookieRun", size: 15)
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titleWeekendColor = .red
        calendar.appearance.headerTitleFont = UIFont(name: "CookieRun", size: 20)
        calendar.appearance.headerTitleColor = .blue
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.weekdayFont = UIFont(name: "CookieRun", size: 18)
        calendar.appearance.weekdayTextColor = .black
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        return calendar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        uiCreate()
    }

    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션 UI
        self.navigationItem.title = self.companyNameOnTable
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        //달력 UI
        self.view.addSubview(self.companyCalendar)
        self.companyCalendar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalTo(400)
        }
    }
    
}
