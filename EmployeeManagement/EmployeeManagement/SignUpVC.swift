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
        let idImage = UIImageView(image: UIImage(systemName: "person.circle"))
        let idTextField = UITextField()
        
        idImage.frame = CGRect(x: 70, y: 160, width: 30, height: 30)
        idImage.tintColor = UIColor.systemGray2
        
        idTextField.frame = CGRect(x: 110, y: 160, width: 200, height: 30)
        idTextField.placeholder = "Id"
        idTextField.borderStyle = .roundedRect
        idTextField.layer.borderWidth = 1
        idTextField.layer.borderColor = UIColor.systemGray2.cgColor
        idTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(idImage)
        self.view.addSubview(idTextField)
        
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
        
        //이름
        let nameImage = UIImageView(image: UIImage(systemName: "face.smiling"))
        let nameTextField = UITextField()
        
        nameImage.frame = CGRect(x: 70, y: 320, width: 30, height: 30)
        nameImage.tintColor = UIColor.systemGray2
        
        nameTextField.frame = CGRect(x: 110, y: 320, width: 200, height: 30)
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.systemGray2.cgColor
        nameTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(nameImage)
        self.view.addSubview(nameTextField)
        
        //생년월일
        let birthImage = UIImageView(image: UIImage(systemName: "calendar"))
        let birthTextField = UITextField()
        
        birthImage.frame = CGRect(x: 70, y: 360, width: 30, height: 30)
        birthImage.tintColor = UIColor.systemGray2
        
        birthTextField.frame = CGRect(x: 110, y: 360, width: 200, height: 30)
        birthTextField.placeholder = "ex) 970101"
        birthTextField.borderStyle = .roundedRect
        birthTextField.layer.borderWidth = 1
        birthTextField.layer.borderColor = UIColor.systemGray2.cgColor
        birthTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(birthImage)
        self.view.addSubview(birthTextField)
        
        //전화번호
        let phoneImage = UIImageView(image: UIImage(systemName: "phone"))
        let phoneTextField = UITextField()
        
        phoneImage.frame = CGRect(x: 70, y: 400, width: 30, height: 30)
        phoneImage.tintColor = UIColor.systemGray2
        
        phoneTextField.frame = CGRect(x: 110, y: 400, width: 200, height: 30)
        phoneTextField.placeholder = "ex) 010-0000-0000"
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor.systemGray2.cgColor
        phoneTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(phoneImage)
        self.view.addSubview(phoneTextField)
    }

}
