//
//  LoginVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/09.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //UI 배치
        uiDeployment()
        
    }
    
    //MARK: UI 배치(No Storyboard)
    func uiDeployment(){
        //로고 이미지
        let logo = UIImage(named: "management")
        let logoImage = UIImageView(image: logo)
        
        logoImage.frame = CGRect(x: self.view.frame.width/2 - 70, y: 200, width: 140, height: 120)
        
        self.view.addSubview(logoImage)
        
        //아이디
        let id = UIImage(systemName: "person.circle")
        let idImage = UIImageView(image: id)
        let idTextField = UITextField()
        
        idImage.frame = CGRect(x: 80, y: 350, width: 30, height: 30)
        idImage.tintColor = UIColor.systemGray4
        
        idTextField.frame = CGRect(x: 120, y: 350, width: 180, height: 30)
        idTextField.placeholder = "id"
        idTextField.borderStyle = .roundedRect
        idTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(idImage)
        self.view.addSubview(idTextField)
        
        //비밀번호
        let pw = UIImage(systemName: "lock.circle")
        let pwImage = UIImageView(image: pw)
        let pwTextField = UITextField()
        
        pwImage.frame = CGRect(x: 80, y: 400, width: 30, height: 30)
        pwImage.tintColor = UIColor.systemGray4
        
        pwTextField.frame = CGRect(x: 120, y: 400, width: 180, height: 30)
        pwTextField.placeholder = "password"
        pwTextField.borderStyle = .roundedRect
        pwTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(pwImage)
        self.view.addSubview(pwTextField)
        
        //로그인 버튼
        let login = UIButton()
        
        login.frame = CGRect(x: 80, y: 450, width: 220, height: 40)
        
        login.setTitle("Login", for: .normal)
        login.setTitleColor(UIColor.black, for: .normal)
        login.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 16)
        login.alpha = 0.7
        
        login.layer.cornerRadius = 3
        login.layer.borderWidth = 2
        login.layer.borderColor = UIColor.systemGray4.cgColor
        
        self.view.addSubview(login)
        
        //아이디,비밀번호 찾기 버튼
        let find = UIButton()
    
        find.frame = CGRect(x: 87, y: 495, width: 140, height: 30)
        
        find.setTitle("Find ID/Find Password", for: .normal)
        find.setTitleColor(UIColor.black, for: .normal)
        find.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 13)
        find.alpha = 0.7
        
        self.view.addSubview(find)
        
        //회원가입 버튼
        let signUP = UIButton()
        
        signUP.frame = CGRect(x: 229, y: 495, width: 64, height: 30)
        
        signUP.setTitle("Sign Up", for: .normal)
        signUP.setTitleColor(UIColor.black, for: .normal)
        signUP.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 13)
        signUP.alpha = 0.7
        
        self.view.addSubview(signUP)
    }

}
