//
//  FindIDVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/10.
//

import UIKit

class FindVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        idUIDeployment()
        passwordUIDeployment()
    }
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @objc func doIdFind(_ sender: UIButton){
        let alert = UIAlertController(title: "아이디", message: "아이디들어올 부분", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    @objc func doPasswordFind(_ sender: UIButton){
        let alert = UIAlertController(title: "비밀번호", message: "비밀번호 들어갈 부분", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    //MARK: UI 배치(Find ID)
    func idUIDeployment(){
        //닫기 버튼
        let closeButton = UIButton()
        
        closeButton.frame = CGRect(x: 20, y: 50, width: 50, height: 40)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 20)
        
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        
        self.view.addSubview(closeButton)
        
        //아이디 찾기 레이블
        let findID = UILabel()
        
        findID.frame = CGRect(x: self.view.frame.width/2 - 80, y: 90, width: 160, height: 50)
        findID.text = "Find ID"
        findID.textColor = UIColor.black
        findID.font = UIFont.init(name: "Chalkboard SE", size: 30)
        findID.textAlignment = .center
        
        self.view.addSubview(findID)
        
        //이름
        let nameImage = UIImageView(image: UIImage(systemName: "face.smiling"))
        let nameTextField = UITextField()
        
        nameImage.frame = CGRect(x: 70, y: 150, width: 30, height: 30)
        nameImage.tintColor = UIColor.systemGray2
        
        nameTextField.frame = CGRect(x: 110, y: 150, width: 200, height: 30)
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
        
        birthImage.frame = CGRect(x: 70, y: 190, width: 30, height: 30)
        birthImage.tintColor = UIColor.systemGray2
        
        birthTextField.frame = CGRect(x: 110, y: 190, width: 200, height: 30)
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
        
        phoneImage.frame = CGRect(x: 70, y: 230, width: 30, height: 30)
        phoneImage.tintColor = UIColor.systemGray2
        
        phoneTextField.frame = CGRect(x: 110, y: 230, width: 200, height: 30)
        phoneTextField.placeholder = "ex) 010-0000-0000"
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor.systemGray2.cgColor
        phoneTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(phoneImage)
        self.view.addSubview(phoneTextField)
        
        //아이디 찾기 버튼
        let findIdButton = UIButton()
        
        findIdButton.frame = CGRect(x: 260, y: 270, width: 50, height: 30)
        
        findIdButton.setTitle("Find", for: .normal)
        findIdButton.setTitleColor(UIColor.black, for: .normal)
        findIdButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 15)
        findIdButton.alpha = 0.7
        
        findIdButton.layer.cornerRadius = 5
        findIdButton.layer.borderWidth = 1
        findIdButton.layer.borderColor = UIColor.black.cgColor
        
        //MARK: 아이디 찾기 버튼 이벤트
        findIdButton.addTarget(self, action: #selector(doIdFind(_:)), for: .touchUpInside)
        
        self.view.addSubview(findIdButton)
    }
    
    //MARK: UI 배치(Find Password)
    func passwordUIDeployment(){
        //비밀번호 레이블
        let findPW = UILabel()
        
        findPW.frame = CGRect(x: self.view.frame.width/2 - 100, y: 340, width: 200, height: 50)
        
        findPW.text = "Find Password"
        findPW.textColor = UIColor.black
        findPW.font = UIFont.init(name: "Chalkboard SE", size: 30)
        findPW.textAlignment = .center
        
        self.view.addSubview(findPW)
        
        //아이디
        let idImage = UIImageView(image: UIImage(systemName: "person.circle"))
        let idTextField = UITextField()
        
        idImage.frame = CGRect(x: 70, y: 405, width: 30, height: 30)
        idImage.tintColor = UIColor.systemGray2
        
        idTextField.frame = CGRect(x: 110, y: 405, width: 200, height: 30)
        idTextField.placeholder = "id"
        idTextField.borderStyle = .roundedRect
        idTextField.layer.borderWidth = 1
        idTextField.layer.borderColor = UIColor.systemGray2.cgColor
        idTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(idImage)
        self.view.addSubview(idTextField)
        
        //비밀번호 질문 창
        let pwQuestionImage = UIImageView(image: UIImage(systemName: "questionmark.circle"))
        let pwLabel = UILabel()
        let pwButton = UIButton()
        
            //이미지
        pwQuestionImage.frame = CGRect(x: 70, y: 445, width: 30, height: 30)
        pwQuestionImage.tintColor = UIColor.systemGray2
        
            //레이블
        pwLabel.frame = CGRect(x: 110, y: 445, width: 150, height: 30)
        pwLabel.text = "Password Question"
        pwLabel.textColor = UIColor.systemGray2
        pwLabel.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        pwLabel.layer.borderWidth = 1
        pwLabel.layer.borderColor = UIColor.systemGray2.cgColor
        
            //버튼
        pwButton.frame = CGRect(x: 270, y: 445, width: 40, height: 30)
        
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
        
        pwAnswerImage.frame = CGRect(x: 70, y: 485, width: 30, height: 30)
        pwAnswerImage.tintColor = UIColor.systemGray2
        
        pwAnswerTextField.frame = CGRect(x: 110, y: 485, width: 200, height: 30)
        pwAnswerTextField.placeholder = "Password Qusetion Answer"
        pwAnswerTextField.borderStyle = .roundedRect
        pwAnswerTextField.layer.borderWidth = 1
        pwAnswerTextField.layer.borderColor = UIColor.systemGray2.cgColor
        pwAnswerTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(pwAnswerImage)
        self.view.addSubview(pwAnswerTextField)
        
        //비밀번호 찾기 버튼
        let findpwButton = UIButton()
        
        findpwButton.frame = CGRect(x: 260, y: 525, width: 50, height: 30)
        
        findpwButton.setTitle("Find", for: .normal)
        findpwButton.setTitleColor(UIColor.black, for: .normal)
        findpwButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 15)
        findpwButton.alpha = 0.7
        
        findpwButton.layer.cornerRadius = 5
        findpwButton.layer.borderWidth = 1
        findpwButton.layer.borderColor = UIColor.black.cgColor
        
        findpwButton.addTarget(self, action: #selector(doPasswordFind(_:)), for: .touchUpInside)
        
        self.view.addSubview(findpwButton)
        
    }
}
