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
        uiCreate()
    }
    
    //MARK: 액션 메소드
    @objc func goNotice(_ sender: UIBarButtonItem) {
        let nv = self.storyboard?.instantiateViewController(withIdentifier: "naviNotice")
        nv!.modalPresentationStyle = .fullScreen
        self.present(nv!, animated: true)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return UITableViewCell() }
        
        if self.viewModel.checkSchedule.contains(indexPath.row) == true {
            cell.checkView.isHidden = true
        } else {
            cell.checkView.isHidden = false
        }
        
        cell.titleLabel.text = "실험중 입니다아아아아아아"
        cell.dateLabel.text = "2022-08-04"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
        let cell = tableView.cellForRow(at: indexPath) as! CalendarCell
        
        if cell.checkView.isHidden == false {
            cell.checkView.isHidden = true
            self.viewModel.checkSchedule.append(indexPath.row)
        }
    }
}
