//
//  CSTabBarController.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/16.
//

import UIKit
class CSTabBarController: UITabBarController{
    
    let csView = UIView()
    
    let listButton = UIButton(type: .custom)
    let listLabel = UILabel()
    
    let chattingButton = UIButton(type: .custom)
    let chattingLabel = UILabel()
    
    let scheduleButton = UIButton(type: .custom)
    let scheduleLabel = UILabel()
    
    let shopButton = UIButton(type: .custom)
    let shopLabel = UILabel()
    
    let transitionButton = UIButton(type: .custom)
    let transitionLabel = UILabel()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //기존 탭바 숨김
        self.tabBar.isHidden = true
        
        //탭바 속성 설정
        self.csView.frame = CGRect(x: 0, y: self.view.frame.height - 90, width: self.view.frame.width, height: 90)
        self.csView.backgroundColor = UIColor.systemGray4
        
        self.view.addSubview(self.csView)
        
        self.uiButton()
        self.uiLabel()
        
        self.onTabBarClick(self.listButton)
    }
    
    //MARK: 액션 메소드
    @objc func onTabBarClick(_ sender: UIButton){
        
        self.listButton.isSelected = false
        self.chattingButton.isSelected = false
        self.scheduleButton.isSelected = false
        self.shopButton.isSelected = false
        self.transitionButton.isSelected = false
        
        sender.isSelected = true
        self.selectedIndex = sender.tag
        
        switch sender{
        case self.listButton:
            self.listLabel.textColor = UIColor.black
            self.chattingLabel.textColor = UIColor.systemGray
            self.scheduleLabel.textColor = UIColor.systemGray
            self.shopLabel.textColor = UIColor.systemGray
            self.transitionLabel.textColor = UIColor.systemGray
        case self.chattingButton:
            self.listLabel.textColor = UIColor.systemGray
            self.chattingLabel.textColor = UIColor.black
            self.scheduleLabel.textColor = UIColor.systemGray
            self.shopLabel.textColor = UIColor.systemGray
            self.transitionLabel.textColor = UIColor.systemGray
        case self.scheduleButton:
            self.listLabel.textColor = UIColor.systemGray
            self.chattingLabel.textColor = UIColor.systemGray
            self.scheduleLabel.textColor = UIColor.black
            self.shopLabel.textColor = UIColor.systemGray
            self.transitionLabel.textColor = UIColor.systemGray
        case self.shopButton:
            self.listLabel.textColor = UIColor.systemGray
            self.chattingLabel.textColor = UIColor.systemGray
            self.scheduleLabel.textColor = UIColor.systemGray
            self.shopLabel.textColor = UIColor.black
            self.transitionLabel.textColor = UIColor.systemGray
        case self.transitionButton:
            self.listLabel.textColor = UIColor.systemGray
            self.chattingLabel.textColor = UIColor.systemGray
            self.scheduleLabel.textColor = UIColor.systemGray
            self.shopLabel.textColor = UIColor.systemGray
            self.transitionLabel.textColor = UIColor.black
        default:
            ""
        }
    }
    
    //MARK: 버튼 속성 메소드
    func uiButton(){
        let tabButtonWidth = 40
        let tabButtonHeight = 40
        
        //리스트 버튼
        self.listButton.frame = CGRect(x: 35, y: 10, width: tabButtonWidth, height: tabButtonHeight)
        self.addTabBarButton(btn: self.listButton, image: UIImage(named: "person")!, tag: 0)
        
        //채팅 버튼
        self.chattingButton.frame = CGRect(x: 105, y: 10, width: tabButtonWidth, height: tabButtonHeight)
        self.addTabBarButton(btn: self.chattingButton, image: UIImage(named: "talk")!, tag: 1)
        
        //스케줄 버튼
        self.scheduleButton.frame = CGRect(x: 175, y: 10, width: tabButtonWidth, height: tabButtonHeight)
        self.addTabBarButton(btn: self.scheduleButton, image: UIImage(named: "schedule")!, tag: 2)
        
        //매장 버튼
        self.shopButton.frame = CGRect(x: 245, y: 10, width: tabButtonWidth, height: tabButtonHeight)
        self.addTabBarButton(btn: self.shopButton, image: UIImage(named: "market")!, tag: 3)
        
        //인수인계 버튼
        self.transitionButton.frame = CGRect(x: 315, y: 10, width: tabButtonWidth, height: tabButtonHeight)
        self.addTabBarButton(btn: self.transitionButton, image: UIImage(named: "recipe")!, tag: 4)
        
        
        self.listButton.isSelected = false
        self.chattingButton.isSelected = false
        self.scheduleButton.isSelected = false
        self.shopButton.isSelected = false
        self.transitionButton.isSelected = false
        
    }
    
    func uiLabel(){
        //리스트 레이블
        self.listLabel.frame = CGRect(x: 30, y: 50, width: 50, height: 20)
        self.listLabel.text = "employees"
        self.listLabel.font = UIFont.init(name: "Chalkboard SE", size: 10)
        self.listLabel.textAlignment = .center
        
        self.csView.addSubview(self.listLabel)
        
        //채팅 레이블
        self.chattingLabel.frame = CGRect(x: 105, y: 50, width: 40, height: 20)
        self.chattingLabel.text = "chatting"
        self.chattingLabel.font = UIFont.init(name: "Chalkboard SE", size: 10)
        self.chattingLabel.textAlignment = .center
        
        self.csView.addSubview(self.chattingLabel)
        
        //스케줄 레이블
        self.scheduleLabel.frame = CGRect(x: 175, y: 50, width: 40, height: 20)
        self.scheduleLabel.text = "schedule"
        self.scheduleLabel.font = UIFont.init(name: "Chalkboard SE", size: 10)
        self.chattingLabel.textAlignment = .center
        
        self.csView.addSubview(self.scheduleLabel)
        
        //매장 레이블
        self.shopLabel.frame = CGRect(x: 245, y: 50, width: 40, height: 20)
        self.shopLabel.text = "shop"
        self.shopLabel.font = UIFont.init(name: "Chalkboard SE", size: 10)
        self.shopLabel.textAlignment = .center
        
        self.csView.addSubview(self.shopLabel)
        
        //레시피 레이블
        self.transitionLabel.frame = CGRect(x: 315, y: 50, width: 40, height: 20)
        self.transitionLabel.text = "recipe"
        self.transitionLabel.font = UIFont.init(name: "Chalkboard SE", size: 10)
        self.transitionLabel.textAlignment = .center
        
        self.csView.addSubview(self.transitionLabel)
    }
    
    func addTabBarButton(btn: UIButton, image: UIImage, tag: Int){
        btn.setImage(image, for: .normal)
        btn.tag = tag
        
        btn.addTarget(self, action: #selector(onTabBarClick(_:)), for: .touchUpInside)
        
        self.csView.addSubview(btn)
    }
    
}
