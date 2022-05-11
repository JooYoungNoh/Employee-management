//
//  SignUpVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/10.
//

import UIKit
import FirebaseFirestore

class SignUpVC: UIViewController {
    
    let pwLabel = UILabel()         //비밀번호 질문 표시할 레이블
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpUIDeployment()
    }
    //MARK: 액션 이벤트
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @objc func doJoin(_ sender: UIButton){
        let alert = UIAlertController(title: nil, message: "회원가입이 완료되었습니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
            
            self.dismiss(animated: true)
        })
        
        self.present(alert, animated: true)
    }
    
    @objc func doCheckId(_ sender: UIButton){
        //아이디 존재 여부 체크하는 코드 넣을 부분
        
        let alert = UIAlertController(title: nil, message: "사용가능한 ID입니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    @objc func doselectedQuesetion(_ sender: UIButton){
        let alert = UIAlertController(title: nil, message: "비밀번호 질문", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default){ (_) in
            //MARK: 피커뷰 선택 바꿀 곳
            self.pwLabel.text = " 이동희"
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        let pickerVC = PickerController()
        alert.setValue(pickerVC, forKey: "contentViewController")
        
        self.present(alert, animated: true)
    }
    
    //MARK: UI 배치(Find ID)
    func signUpUIDeployment(){
        //닫기 버튼
        let closeButton = UIButton()
        
        closeButton.frame = CGRect(x: 20, y: 50, width: 50, height: 40)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 20)
        
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        
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
        let idButton = UIButton()
        
            //이미지
        idImage.frame = CGRect(x: 70, y: 160, width: 30, height: 30)
        idImage.tintColor = UIColor.systemGray2
        
            //텍스트필드
        idTextField.frame = CGRect(x: 110, y: 160, width: 150, height: 30)
        idTextField.placeholder = "Id"
        idTextField.borderStyle = .roundedRect
        idTextField.layer.borderWidth = 1
        idTextField.layer.borderColor = UIColor.systemGray2.cgColor
        idTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
            //버튼
        idButton.frame = CGRect(x: 270, y: 160, width: 40, height: 30)
    
        idButton.setTitle("확인", for: .normal)
        idButton.setTitleColor(UIColor.black, for: .normal)
        idButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 15)
        idButton.alpha = 0.7
    
        idButton.layer.cornerRadius = 5
        idButton.layer.borderWidth = 1
        idButton.layer.borderColor = UIColor.black.cgColor
        
        //MARK: 아이디 확인 버튼 이벤트
        idButton.addTarget(self, action: #selector(doCheckId(_:)), for: .touchUpInside)
        
        self.view.addSubview(idImage)
        self.view.addSubview(idTextField)
        self.view.addSubview(idButton)
        
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
        
        //MARK: 비밀번호 질문 창 버튼 이벤트
        pwButton.addTarget(self, action: #selector(doselectedQuesetion(_:)), for: .touchUpInside)
        
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
        
        //성별
        let genderImage = UIImageView(image: UIImage(systemName: "person.fill.questionmark"))
        let genderControl = UISegmentedControl(items: ["남자","여자"])
        
        genderImage.frame = CGRect(x: 70, y: 440, width: 30, height: 25)
        genderImage.tintColor = UIColor.systemGray2
        
        genderControl.frame = CGRect(x: 110, y: 440, width: 200, height: 25)
        genderControl.selectedSegmentIndex = 0
            
        self.view.addSubview(genderImage)
        self.view.addSubview(genderControl)
        
        //직책
        let jobImage = UIImageView(image: UIImage(systemName: "person.text.rectangle"))
        let jobControl = UISegmentedControl(items: ["사장", "직원", "알바"])
        
        jobImage.frame = CGRect(x: 70, y: 475, width: 30, height: 25)
        jobImage.tintColor = UIColor.systemGray2
        
        jobControl.frame = CGRect(x: 110, y: 475, width: 200, height: 25)
        jobControl.selectedSegmentIndex = 0
        
        self.view.addSubview(jobImage)
        self.view.addSubview(jobControl)
        
        //완료 버튼
        let successButton = UIButton()
        
        successButton.frame = CGRect(x: 70, y: 520, width: 240, height: 50)
        
        successButton.setTitle("Join", for: .normal)
        successButton.setTitleColor(UIColor.black, for: .normal)
        successButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 20)
        successButton.alpha = 0.7
        
        successButton.layer.cornerRadius = 3
        successButton.layer.borderWidth = 2
        successButton.layer.borderColor = UIColor.systemGray.cgColor
        
        //MARK: Join 버튼 이벤트
        successButton.addTarget(self, action: #selector(doJoin(_:)), for: .touchUpInside)
        
        self.view.addSubview(successButton)
    }

}
