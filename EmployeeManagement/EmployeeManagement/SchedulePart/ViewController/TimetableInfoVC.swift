//
//  TimetableInfoVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/15.
//

import UIKit

class TimetableInfoVC: UIViewController {

    //이름 레이블
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름:"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let nameResult: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    //날짜 레이블
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜:"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let dateResult: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    //시작 시간
    let startLabel: UILabel = {
        let label = UILabel()
        label.text = "시작 시간:"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let startTF: UITextField = {
        let text = UITextField()
        text.backgroundColor = .systemGray6
        text.placeholder = "00:00"
        text.textColor = .black
        text.textAlignment = .center
        text.font = UIFont(name: "CookieRun", size: 18)
        text.layer.cornerRadius = 10
        text.layer.masksToBounds = true
        text.layer.borderWidth = 0
        return text
    }()
    
    //끝 시간
    let endLabel: UILabel = {
        let label = UILabel()
        label.text = "끝 시간:"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let endTF: UITextField = {
        let text = UITextField()
        text.backgroundColor = .systemGray6
        text.placeholder = "00:00"
        text.textColor = .black
        text.textAlignment = .center
        text.font = UIFont(name: "CookieRun", size: 18)
        text.layer.cornerRadius = 10
        text.layer.masksToBounds = true
        text.layer.borderWidth = 0
        return text
    }()
    
    let nextButton: UIButton = {
        let button  = UIButton()
        button.setTitle(" 다음날", for: .normal)
        button.setTitleColor(UIColor.systemGray5, for: .normal)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .systemGray5
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 18)
        return button
    }()
    
    //총 시간
    let allLabel: UILabel = {
        let label = UILabel()
        label.text = "총 시간"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let allResult: UILabel = {
        let label = UILabel()
        label.text = "0.0 시간"
        label.textAlignment = .center
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    //할 일
    let workLabel: UILabel = {
        let label = UILabel()
        label.text = "할 일:"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let workTV: UITextView = {
       let write = UITextView()
        write.textColor = .black
        write.font = UIFont(name: "CookieRun", size: 18)
        write.textAlignment = .left
        write.backgroundColor = .systemGray6
        write.layer.cornerRadius = 10
        write.layer.masksToBounds = true
        write.layer.borderWidth = 0
        return write
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.uiCreate()
    }
    
    //MARK: 액션 메소드
    @objc func checkNextDay(_ sender: UIButton){
        
    }
    
    //MARK: 화면 메소드
    func uiCreate(){
        //이름 레이블
        self.view.addSubview(self.nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.nameResult.text = "노주영"
        self.view.addSubview(self.nameResult)
        self.nameResult.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalTo(self.nameLabel.snp.trailing).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(80)
        
        }
        
        //날짜 레이블 UI
        self.view.addSubview(self.dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(50)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.dateResult.text = "self.dateOnTable"
        self.view.addSubview(self.dateResult)
        dateResult.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        //시작 시간 레이블 UI
        self.view.addSubview(self.startLabel)
        startLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.dateLabel.snp.leading)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.startTF)
        startTF.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        //끝 시간 레이블 UI
        self.view.addSubview(self.endLabel)
        endLabel.snp.makeConstraints { make in
            make.top.equalTo(self.startLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.dateLabel.snp.leading)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.endTF)
        endTF.snp.makeConstraints { make in
            make.top.equalTo(self.startLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        self.nextButton.addTarget(self, action: #selector(checkNextDay(_:)), for: .touchUpInside)
        self.view.addSubview(self.nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(self.startLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.endTF.snp.trailing).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        //총 시간 레이블 UI
        self.view.addSubview(self.allLabel)
        allLabel.snp.makeConstraints { make in
            make.top.equalTo(self.endLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.dateLabel.snp.leading)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.allResult)
        allResult.snp.makeConstraints { make in
            make.top.equalTo(self.endLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        //할 일 레이블 UI
        self.view.addSubview(self.workLabel)
        workLabel.snp.makeConstraints { make in
            make.top.equalTo(self.allLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.dateLabel.snp.leading)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.workTV)
        workTV.snp.makeConstraints { make in
            make.top.equalTo(self.allLabel.snp.bottom).offset(40)
            make.leading.equalTo(self.workLabel.snp.trailing).offset(20)
            make.bottom.equalTo(self.view.snp.bottom).offset(-100)
            make.width.equalTo(230)
        }
    
    }
    
    //MARK: tap 제스쳐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
