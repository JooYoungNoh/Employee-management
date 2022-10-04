//
//  CSTabBarController.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/16.
//

import UIKit
import SnapKit

class CSTabBarController: UITabBarController{
    
    let csView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        return view
    }()
    
    //직원 리스트
    let listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "person"), for: .normal)
        button.tintColor = .black
        button.tag = 0
        button.isSelected = false
        return button
    }()
    let listLabel: UILabel = {
        let label = UILabel()
        label.text = "employees"
        label.font = UIFont.init(name: "CookieRun", size: 10)
        label.textAlignment = .center
        return label
    }()
    
    //채팅 리스트
    let chattingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "talk"), for: .normal)
        button.tintColor = .black
        button.tag = 1
        button.isSelected = false
        return button
    }()
    let chattingLabel: UILabel = {
        let label = UILabel()
        label.text = "chatting"
        label.font = UIFont.init(name: "CookieRun", size: 10)
        label.textAlignment = .center
        return label
    }()
    
    //스케쥴 리스트
    let scheduleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "schedule"), for: .normal)
        button.tintColor = .black
        button.tag = 2
        button.isSelected = false
        return button
    }()
    let scheduleLabel: UILabel = {
        let label = UILabel()
        label.text = "schedule"
        label.font = UIFont.init(name: "CookieRun", size: 10)
        label.textAlignment = .center
        return label
    }()
    
    //매장 리스트
    let shopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "market"), for: .normal)
        button.tintColor = .black
        button.tag = 3
        button.isSelected = false
        return button
    }()
    let shopLabel: UILabel = {
        let label = UILabel()
        label.text = "shop"
        label.font = UIFont.init(name: "CookieRun", size: 10)
        label.textAlignment = .center
        return label
    }()
    
    //레시피 리스트
    let recipeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recipe"), for: .normal)
        button.tintColor = .black
        button.tag = 4
        button.isSelected = false
        return button
    }()
    let recipeLabel: UILabel = {
        let label = UILabel()
        label.text = "recipe"
        label.font = UIFont.init(name: "CookieRun", size: 10)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //기존 탭바 숨김
        self.tabBar.isHidden = true
        
        self.uiCreate()
        self.onTabBarClick(self.listButton)
    }
    
    //MARK: 액션 메소드
    @objc func onTabBarClick(_ sender: UIButton){
        
        self.listButton.isSelected = false
        self.chattingButton.isSelected = false
        self.scheduleButton.isSelected = false
        self.shopButton.isSelected = false
        self.recipeButton.isSelected = false
        
        sender.isSelected = true
        self.selectedIndex = sender.tag
        
        switch sender{
        case self.listButton:
            self.listLabel.textColor = UIColor.black
            self.chattingLabel.textColor = UIColor.systemGray
            self.scheduleLabel.textColor = UIColor.systemGray
            self.shopLabel.textColor = UIColor.systemGray
            self.recipeLabel.textColor = UIColor.systemGray
        case self.chattingButton:
            self.listLabel.textColor = UIColor.systemGray
            self.chattingLabel.textColor = UIColor.black
            self.scheduleLabel.textColor = UIColor.systemGray
            self.shopLabel.textColor = UIColor.systemGray
            self.recipeLabel.textColor = UIColor.systemGray
        case self.scheduleButton:
            self.listLabel.textColor = UIColor.systemGray
            self.chattingLabel.textColor = UIColor.systemGray
            self.scheduleLabel.textColor = UIColor.black
            self.shopLabel.textColor = UIColor.systemGray
            self.recipeLabel.textColor = UIColor.systemGray
        case self.shopButton:
            self.listLabel.textColor = UIColor.systemGray
            self.chattingLabel.textColor = UIColor.systemGray
            self.scheduleLabel.textColor = UIColor.systemGray
            self.shopLabel.textColor = UIColor.black
            self.recipeLabel.textColor = UIColor.systemGray
        case self.recipeButton:
            self.listLabel.textColor = UIColor.systemGray
            self.chattingLabel.textColor = UIColor.systemGray
            self.scheduleLabel.textColor = UIColor.systemGray
            self.shopLabel.textColor = UIColor.systemGray
            self.recipeLabel.textColor = UIColor.black
        default:
            ""
        }
    }
    
    //MARK: 화면 메소드
    func uiCreate(){
        //속성 크기 설정
        let buttonOffset = (self.view.frame.width - 200) / 6
        
        //탭바
        self.view.addSubview(self.csView)
        self.csView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(90)
        }
        
        //직원리스트
        //버튼
        self.listButton.addTarget(self, action: #selector(onTabBarClick(_:)), for: .touchUpInside)
        self.csView.addSubview(self.listButton)
        self.listButton.snp.makeConstraints { make in
            make.leading.equalTo(self.csView.snp.leading).offset(buttonOffset)
            make.top.equalTo(self.csView.snp.top).offset(10)
            make.width.height.equalTo(40)
        }
        //레이블
        self.csView.addSubview(self.listLabel)
        self.listLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.listButton.snp.leading).offset(-15)
            make.trailing.equalTo(self.listButton.snp.trailing).offset(15)
            make.top.equalTo(self.listButton.snp.bottom)
            make.height.equalTo(20)
        }
        
        //채팅 리스트
        //버튼
        self.chattingButton.addTarget(self, action: #selector(onTabBarClick(_:)), for: .touchUpInside)
        self.csView.addSubview(self.chattingButton)
        self.chattingButton.snp.makeConstraints { make in
            make.leading.equalTo(self.listButton.snp.trailing).offset(buttonOffset)
            make.top.equalTo(self.csView.snp.top).offset(10)
            make.width.height.equalTo(40)
        }
        //레이블
        self.csView.addSubview(self.chattingLabel)
        self.chattingLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.chattingButton.snp.leading).offset(-15)
            make.trailing.equalTo(self.chattingButton.snp.trailing).offset(15)
            make.top.equalTo(self.chattingButton.snp.bottom)
            make.height.equalTo(20)
        }
        
        //스케쥴 리스트
        //버튼
        self.scheduleButton.addTarget(self, action: #selector(onTabBarClick(_:)), for: .touchUpInside)
        self.csView.addSubview(self.scheduleButton)
        self.scheduleButton.snp.makeConstraints { make in
            make.leading.equalTo(self.chattingButton.snp.trailing).offset(buttonOffset)
            make.top.equalTo(self.csView.snp.top).offset(10)
            make.width.height.equalTo(40)
        }
        //레이블
        self.csView.addSubview(self.scheduleLabel)
        self.scheduleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.scheduleButton.snp.leading).offset(-15)
            make.trailing.equalTo(self.scheduleButton.snp.trailing).offset(15)
            make.top.equalTo(self.scheduleButton.snp.bottom)
            make.height.equalTo(20)
        }
        
        //매장 리스트
        //버튼
        self.shopButton.addTarget(self, action: #selector(onTabBarClick(_:)), for: .touchUpInside)
        self.csView.addSubview(self.shopButton)
        self.shopButton.snp.makeConstraints { make in
            make.leading.equalTo(self.scheduleButton.snp.trailing).offset(buttonOffset)
            make.top.equalTo(self.csView.snp.top).offset(10)
            make.width.height.equalTo(40)
        }
        //레이블
        self.csView.addSubview(self.shopLabel)
        self.shopLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.shopButton.snp.leading).offset(-15)
            make.trailing.equalTo(self.shopButton.snp.trailing).offset(15)
            make.top.equalTo(self.shopButton.snp.bottom)
            make.height.equalTo(20)
        }
        
        //레시피 리스트
        //버튼
        self.recipeButton.addTarget(self, action: #selector(onTabBarClick(_:)), for: .touchUpInside)
        self.csView.addSubview(self.recipeButton)
        self.recipeButton.snp.makeConstraints { make in
            make.leading.equalTo(self.shopButton.snp.trailing).offset(buttonOffset)
            make.top.equalTo(self.csView.snp.top).offset(10)
            make.width.height.equalTo(40)
        }
        //레이블
        self.csView.addSubview(self.recipeLabel)
        self.recipeLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.recipeButton.snp.leading).offset(-15)
            make.trailing.equalTo(self.recipeButton.snp.trailing).offset(15)
            make.top.equalTo(self.recipeButton.snp.bottom)
            make.height.equalTo(20)
        }
    }
}
