//
//  ShopInformationVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/19.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class ShopInformationVC: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var imgExistence: Bool!                  //이미지 유무
    
    let background = UILabel()              //명함 배경
    
    let logoImage = UIImageView()           //로고 이미지
    
    let companyName = UILabel()             //회사 이름
    let ceoNameLabel = UILabel()            //대표자 이름
    let ceoPhoneLabel = UILabel()           //대표자 번호
    
    let businessType = UILabel()            //업종
    let employeeNumber = UILabel()          //사원수
    
    let requestButton = UIButton()          //등록 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiDeployment()
    }
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: 메소드
    func uiDeployment(){
        //닫기 버튼 UI
        let backButton = UIButton()
        
        backButton.frame = CGRect(x: 20, y: 50, width: 60, height: 40)
        
        backButton.setTitle("< Back", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 20)
        
        backButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        
        //편집 버튼 UI
        let editButton = UIButton()
        
        editButton.frame = CGRect(x: 320, y: 50, width: 60, height: 40)
        
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(UIColor.black, for: .normal)
        editButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 20)
        
        self.view.addSubview(editButton)
        
        //화면 타이틀 UI
        let uiTitle = UILabel()
        
        uiTitle.frame = CGRect(x: self.view.frame.width / 2 - 130, y: 230, width: 260, height: 50)
        
        uiTitle.text = "Company Information"
        uiTitle.font = UIFont.init(name: "Chalkboard SE", size: 25)
        uiTitle.textColor = UIColor.black
        
        self.view.addSubview(uiTitle)
        
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
        
      /*  //이미지 터치 시 이미지 변경
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectlogo(_:)))
        self.logoImage.addGestureRecognizer(tap)
        self.logoImage.isUserInteractionEnabled = true
        */
        self.view.addSubview(self.logoImage)
        
        //회사명 UI
        self.companyName.frame = CGRect(x: 160, y: self.view.frame.height / 2 - 90, width: 190, height: 50)
        
        self.companyName.text = "네이버"
        //self.companyName.textAlignment = .right
        self.companyName.font = UIFont.init(name: "Chalkboard SE", size: 30)
        
        self.view.addSubview(self.companyName)
        
        //대표자 레이블 UI
        self.ceoNameLabel.frame = CGRect(x: 160, y: self.view.frame.height / 2 - 10, width: 190, height: 40)
        self.ceoNameLabel.text = "CEO 노주영"
        self.ceoNameLabel.font = UIFont.init(name: "Chalkboard SE", size: 25)
        self.ceoNameLabel.textAlignment = .right
        
        
        self.view.addSubview(self.ceoNameLabel)
        
        //전화번호 레이블 UI
        self.ceoPhoneLabel.frame = CGRect(x: 160, y: self.view.frame.height / 2 + 35, width: 190, height: 20)
        self.ceoPhoneLabel.text = "01011111111"
        self.ceoPhoneLabel.font = UIFont.init(name: "Chalkboard SE", size: 15)
        self.ceoPhoneLabel.textAlignment = .right
        
        self.view.addSubview(self.ceoPhoneLabel)
        
        //업종 레이블 UI
        self.businessType.frame = CGRect(x: 170, y: self.view.frame.height / 2 + 50, width: 140, height: 30)
        self.businessType.text = "서비스업"
        self.businessType.textAlignment = .right
        self.businessType.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(self.businessType)
        
        //사원수 레이블 UI
        self.employeeNumber.frame = CGRect(x: 310, y: self.view.frame.height / 2 + 50, width: 40, height: 30)
        
        self.employeeNumber.text = "1명"
        self.employeeNumber.textAlignment = .right
        self.employeeNumber.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(self.employeeNumber)

        //가입 신청 버튼
        self.requestButton.frame = CGRect(x: self.view.frame.width / 2 - 60, y: self.view.frame.height / 2 + 130, width: 120, height: 40)
        self.requestButton.setTitle("Request Join", for: .normal)
        self.requestButton.setTitleColor(UIColor.black, for: .normal)
        self.requestButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 16)
        self.requestButton.alpha = 0.7
        
        self.requestButton.layer.cornerRadius = 3
        self.requestButton.layer.borderColor = UIColor.systemGray.cgColor
        self.requestButton.layer.borderWidth = 2
        
       // self.registerButton.addTarget(self, action: #selector(doregister(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.requestButton)
    }

}
