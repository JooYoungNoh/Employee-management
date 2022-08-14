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
    
    var viewModel = CalendarVM()
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
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
        self.companyCalendar.delegate = self
        uiCreate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.findMySchedule(companyNameOnTable: self.companyNameOnTable){ completion in
            self.tableView.reloadData()
            print(completion)
        }
    }
    
    //MARK: 액션 메소드
    @objc func goNotice(_ sender: UIBarButtonItem) {
        self.viewModel.goNotice(uv: self, companyNameOnTable: self.companyNameOnTable)
    }
    

    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션 UI
        self.navigationItem.title = self.companyNameOnTable
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        //내비게이션 바 버튼
        let noticeButton = UIBarButtonItem.init(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(goNotice(_:)))
        self.navigationItem.rightBarButtonItem = noticeButton
        noticeButton.tintColor = UIColor.black
        
        //달력 UI
        self.view.addSubview(self.companyCalendar)
        self.companyCalendar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalTo(400)
        }
        
        //테이블 뷰 UI
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.companyCalendar.snp.bottom).offset(5)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(5)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-5)
            make.bottom.equalTo(self.view.snp.bottom).offset(-100)
        }
    }
}

//MARK: 테이블 뷰 메소드
extension CalendarVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.viewModel.cellInfo(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.companyMyScheduleList.count == 0 ? 1 : self.viewModel.companyMyScheduleList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //셀 타이틀
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let csview = UIView()
        let listTitle = UILabel()
        
        csview.backgroundColor = UIColor.white
            
        listTitle.frame = CGRect(x: 20, y: 0, width: self.view.frame.width / 2, height: 30)
        listTitle.font = UIFont.init(name: "CookieRun", size: 20)
        listTitle.text = "내 스케줄"
        listTitle.textColor = UIColor.blue
        
        csview.addSubview(listTitle)
        return csview
    }
    
    //셀 선택
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.selectCell(tableView: tableView, indexPath: indexPath, companyNameOnTable: self.companyNameOnTable)
    }
}

//MARK: calendar 메소드
extension CalendarVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.viewModel.goTimetable(uv: self, date: date, companyNameOnTable: self.companyNameOnTable)
    }
}
