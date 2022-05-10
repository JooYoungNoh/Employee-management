//
//  SignUpVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/10.
//

import UIKit

class SignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        signUpUIDeployment()
    }
    
    //MARK: UI 배치(Find ID)
    func signUpUIDeployment(){
        //닫기 버튼
        let closeButton = UIButton()
        
        closeButton.frame = CGRect(x: 20, y: 50, width: 50, height: 40)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 20)
        
        self.view.addSubview(closeButton)
        
        //아이디 찾기 레이블
        let signUp = UILabel()
        
        signUp.frame = CGRect(x: self.view.frame.width/2 - 80, y: 90, width: 160, height: 50)
        signUp.text = "Sign Up"
        signUp.textColor = UIColor.black
        signUp.font = UIFont.init(name: "Chalkboard SE", size: 30)
        signUp.textAlignment = .center
        
        self.view.addSubview(signUp)
    }

}
