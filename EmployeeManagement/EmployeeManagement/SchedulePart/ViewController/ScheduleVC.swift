//
//  ScheduleVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/16.
//

import UIKit
import SnapKit

class ScheduleVC: UIViewController {
    
    let myLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CookieRun", size: 20)
        label.text = " 선택해주세요"
        label.textColor = UIColor.blue
        return label
    }()
    
    let myButton: UIButton = {
        let button = UIButton()
        button.setTitle("내 스케줄", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        return button
    }()
    
    let companyButton: UIButton = {
        let button = UIButton()
        button.setTitle("회사 스케줄", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        return button
    }()
    
    let noticeButton: UIButton = {
        let button = UIButton()
        button.setTitle("공지사항", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        return button
    }()
    
    let noticeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 10)
        label.text = "100"
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .red
        label.layer.cornerRadius = 15
        label.layer.borderWidth = 0
        label.layer.masksToBounds = true
        return label
    }()
    
    
    //MARK: viewDIdLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        uiCreate()
        
    }
    
    //MARK: 액션 메소드
    @objc func goSetting(_ sender: UIBarButtonItem){
        
    }
    
    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션
        self.navigationItem.title = "Schedule"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 30)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //내비게이션 바 버튼
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goSetting(_:)))
        
        self.navigationItem.rightBarButtonItem = settingButton
        settingButton.tintColor = UIColor.black
        
        self.view.addSubview(self.myLabel)
        self.myLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.myButton)
        self.myButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.companyButton)
        self.companyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.myButton.snp.top).offset(-50)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.noticeButton)
        self.noticeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.myButton.snp.bottom).offset(50)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.noticeLabel)
        self.noticeLabel.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalTo(self.noticeButton.snp.top).offset(-15)
            make.trailing.equalTo(self.noticeButton.snp.trailing).offset(15)
        }
    }

}
