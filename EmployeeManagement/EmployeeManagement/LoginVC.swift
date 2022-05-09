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
        //MARK: UI 배치(No Storyboard)
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
        idTextField.font = UIFont.init(name: "Chalkboard SE", size: 14)
        
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
        pwTextField.font = UIFont.init(name: "Chalkboard SE", size: 14)
        
        self.view.addSubview(pwImage)
        self.view.addSubview(pwTextField)

    }
    

}
