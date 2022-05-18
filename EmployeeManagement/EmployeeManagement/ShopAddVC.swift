//
//  ShopAddVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/17.
//

import UIKit

class ShopAddVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let background = UILabel()              //명함 배경
    
    let logoImage = UIImageView()           //로고 이미지
    let logoButton = UIButton()             //로고 버튼
    
    let companyTextfield = UITextField()    //회사 이름
    let ceoNameLabel = UILabel()            //대표자 이름
    let ceoPhoneLabel = UILabel()           //대표자 번호
    
    let businessType = UILabel()            //업종
    let businessButton = UIButton()         //업종 선택 버튼
    
    let registerButton = UIButton()         //등록 버튼
    

    override func viewDidLoad() {
        super.viewDidLoad()

        uiDeployment()
        
    }
    
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    //MARK: 메소드
    func uiDeployment(){
        appDelegate.phoneInfo = "01031201798"        //연습용
        appDelegate.nameInfo = "노주영"                //연습용
        
        //닫기 버튼 UI
        let closeButton = UIButton()
        
        closeButton.frame = CGRect(x: 20, y: 50, width: 50, height: 40)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 20)
        
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        
        self.view.addSubview(closeButton)
        
        //명함 배경 UI
        self.background.frame = CGRect(x: 20, y: self.view.frame.height / 2 - 100, width: 350, height: 200)
        self.background.backgroundColor = UIColor.white
        self.background.layer.cornerRadius = 10
        self.background.layer.borderWidth = 2
        self.background.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(self.background)
        
        //회사 로고 이미지 뷰 UI
        self.logoImage.frame = CGRect(x: 40, y: self.view.frame.height / 2 - 80, width: 100, height: 100)
        self.logoImage.backgroundColor = UIColor.systemGray3
        
        self.view.addSubview(self.logoImage)
        
        //로고 버튼 UI
        self.logoButton.frame = CGRect(x: 60, y: self.view.frame.height / 2 + 25, width: 60, height: 30)
        self.logoButton.setTitle("선택", for: .normal)
        self.logoButton.setTitleColor(UIColor.black, for: .normal)
        self.logoButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 14)
        
        self.logoButton.layer.cornerRadius = 5
        self.logoButton.layer.borderColor = UIColor.systemGray2.cgColor
        self.logoButton.layer.borderWidth = 1
        
        self.view.addSubview(self.logoButton)
        
        //회사명 텍스트 필드 UI
        self.companyTextfield.frame = CGRect(x: 160, y: self.view.frame.height / 2 - 80, width: 190, height: 30)
        self.companyTextfield.placeholder = "Company"
        self.companyTextfield.font = UIFont.init(name: "Chalkboard SE", size: 14)
        
        self.companyTextfield.layer.borderWidth = 1
        self.companyTextfield.layer.borderColor = UIColor.systemGray2.cgColor
        self.companyTextfield.borderStyle = .roundedRect
        
        self.view.addSubview(self.companyTextfield)
        
        //대표자 레이블 UI
        self.ceoNameLabel.frame = CGRect(x: 160, y: self.view.frame.height / 2 - 40, width: 190, height: 30)
        self.ceoNameLabel.text = " \(self.appDelegate.nameInfo!)"
        self.ceoNameLabel.font = UIFont.init(name: "Chalkboard SE", size: 14)
        
        self.ceoNameLabel.layer.borderWidth = 1
        self.ceoNameLabel.layer.borderColor = UIColor.systemGray2.cgColor
        
        self.view.addSubview(self.ceoNameLabel)
        
        //대표자 레이블 UI
        self.ceoPhoneLabel.frame = CGRect(x: 160, y: self.view.frame.height / 2, width: 190, height: 30)
        self.ceoPhoneLabel.text = " \(self.appDelegate.phoneInfo!)"
        self.ceoPhoneLabel.font = UIFont.init(name: "Chalkboard SE", size: 14)
        
        self.ceoPhoneLabel.layer.borderWidth = 1
        self.ceoPhoneLabel.layer.borderColor = UIColor.systemGray2.cgColor
        
        self.view.addSubview(self.ceoPhoneLabel)
        
        //업종 레이블 UI
        self.businessType.frame = CGRect(x: 160, y: self.view.frame.height / 2 + 40, width: 140, height: 30)
        self.businessType.text = " Select businessType"
        self.businessType.font = UIFont.init(name: "Chalkboard SE", size: 14)
        self.businessType.alpha = 0.7
        
        self.businessType.layer.borderWidth = 1
        self.businessType.layer.borderColor = UIColor.systemGray2.cgColor
        
        self.view.addSubview(self.businessType)
        
        //업종 선택 버튼 UI
        self.businessButton.frame = CGRect(x: 310, y: self.view.frame.height / 2 + 40, width: 40, height: 30)
        self.businessButton.setTitle("선택", for: .normal)
        self.businessButton.setTitleColor(UIColor.black, for: .normal)
        self.businessButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 14)
        
        self.businessButton.layer.cornerRadius = 5
        self.businessButton.layer.borderColor = UIColor.systemGray2.cgColor
        self.businessButton.layer.borderWidth = 1
        
        self.view.addSubview(self.businessButton)
        
        //등록 버튼
        self.registerButton.frame = CGRect(x: self.view.frame.width / 2 - 60, y: self.view.frame.height / 2 + 130, width: 120, height: 40)
        self.registerButton.setTitle("register", for: .normal)
        self.registerButton.setTitleColor(UIColor.black, for: .normal)
        self.registerButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 16)
        self.registerButton.alpha = 0.7
        
        self.registerButton.layer.cornerRadius = 3
        self.registerButton.layer.borderColor = UIColor.systemGray.cgColor
        self.registerButton.layer.borderWidth = 2
        
        self.view.addSubview(self.registerButton)
    }

}
