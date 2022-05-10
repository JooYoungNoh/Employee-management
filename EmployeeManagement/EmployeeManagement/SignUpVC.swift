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
        
        //회원가입 레이블
        let signUp = UILabel()
        
        signUp.frame = CGRect(x: self.view.frame.width/2 - 80, y: 90, width: 160, height: 50)
        signUp.text = "Sign Up"
        signUp.textColor = UIColor.black
        signUp.font = UIFont.init(name: "Chalkboard SE", size: 30)
        signUp.textAlignment = .center
        
        self.view.addSubview(signUp)
        
        //아이디
        let nameImage = UIImageView(image: UIImage(systemName: "person.circle"))
        let nameTextField = UITextField()
        
        nameImage.frame = CGRect(x: 70, y: 160, width: 30, height: 30)
        nameImage.tintColor = UIColor.systemGray2
        
        nameTextField.frame = CGRect(x: 110, y: 160, width: 200, height: 30)
        nameTextField.placeholder = "Id"
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.systemGray2.cgColor
        nameTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(nameImage)
        self.view.addSubview(nameTextField)
        
        //비밀번호
        let passwordImage = UIImageView(image: UIImage(systemName: "lock.circle"))
        let passwordTextField = UITextField()
        
        passwordImage.frame = CGRect(x: 70, y: 200, width: 30, height: 30)
        passwordImage.tintColor = UIColor.systemGray2
        
        passwordTextField.frame = CGRect(x: 110, y: 200, width: 200, height: 30)
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.systemGray2.cgColor
        passwordTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(passwordImage)
        self.view.addSubview(passwordTextField)
        
        //비밀번호 질문 창
        let pwQuestionImage = UIImageView(image: UIImage(systemName: "questionmark.circle"))
        let pwLabel = UILabel()
        let pwButton = UIButton()
        
            //이미지
        pwQuestionImage.frame = CGRect(x: 70, y: 240, width: 30, height: 30)
        pwQuestionImage.tintColor = UIColor.systemGray2
        
            //레이블
        pwLabel.frame = CGRect(x: 110, y: 240, width: 150, height: 30)
        pwLabel.text = " Password Question"
        pwLabel.textColor = UIColor.systemGray2
        pwLabel.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        pwLabel.layer.borderWidth = 1
        pwLabel.layer.borderColor = UIColor.systemGray2.cgColor
        
            //버튼
        pwButton.frame = CGRect(x: 270, y: 240, width: 40, height: 30)
        
        pwButton.setTitle("선택", for: .normal)
        pwButton.setTitleColor(UIColor.black, for: .normal)
        pwButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 15)
        pwButton.alpha = 0.7
        
        pwButton.layer.cornerRadius = 5
        pwButton.layer.borderWidth = 1
        pwButton.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(pwQuestionImage)
        self.view.addSubview(pwLabel)
        self.view.addSubview(pwButton)
        
        //비밀번호 질문 답변 창
        let pwAnswerImage = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        let pwAnswerTextField = UITextField()
        
        pwAnswerImage.frame = CGRect(x: 70, y: 280, width: 30, height: 30)
        pwAnswerImage.tintColor = UIColor.systemGray2
        
        pwAnswerTextField.frame = CGRect(x: 110, y: 280, width: 200, height: 30)
        pwAnswerTextField.placeholder = "Password Qusetion Answer"
        pwAnswerTextField.borderStyle = .roundedRect
        pwAnswerTextField.layer.borderWidth = 1
        pwAnswerTextField.layer.borderColor = UIColor.systemGray2.cgColor
        pwAnswerTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(pwAnswerImage)
        self.view.addSubview(pwAnswerTextField)
    }

}
