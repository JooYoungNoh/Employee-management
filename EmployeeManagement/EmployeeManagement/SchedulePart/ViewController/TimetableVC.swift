//
//  TimetableVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/09.
//

import UIKit
import SnapKit

class TimetableVC: UIViewController {

    var dateOnTable: String = ""
    
    var viewModel = TimetableVM()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 17)
        label.text = "이름:"
        label.textAlignment = .center
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 17)
        label.text = "시간:"
        label.textAlignment = .center
        return label
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiCreate()
    }
    
    //MARK: 액션 메소드
    @objc func addTimetable(_ sender: UIBarButtonItem){
        
    }
    
    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션
        self.navigationItem.title = self.dateOnTable
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        //내비게이션 바 버튼
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addTimetable(_:)))
        
        self.navigationItem.rightBarButtonItem = addButton
        addButton.tintColor = UIColor.black
        
        //개인 시간 정보
        self.view.addSubview(self.nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(45)
            make.width.equalTo(130)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.nameLabel.snp.trailing).offset(10)
            make.width.equalTo(140)
            make.height.equalTo(30)
        }
        
    }

}
