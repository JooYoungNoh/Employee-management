//
//  SignUpVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/10.
//

import UIKit
import FirebaseFirestore

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore()  //데이터베이스
    
    //아이디
    let idImage = UIImageView(image: UIImage(systemName: "person.circle"))
    let idTextField = UITextField()
    //비밀번호
    let passwordImage = UIImageView(image: UIImage(systemName: "lock.circle"))
    let passwordTextField = UITextField()
    //비밀번호 질문 창
    let pwQuestionImage = UIImageView(image: UIImage(systemName: "questionmark.circle"))
    let pwLabel = UILabel()
    //비밀번호 질문 답변 창
    let pwAnswerImage = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
    let pwAnswerTextField = UITextField()
    //이름
    let nameImage = UIImageView(image: UIImage(systemName: "face.smiling"))
    let nameTextField = UITextField()
    //생년월일
    let birthImage = UIImageView(image: UIImage(systemName: "calendar"))
    let birthTextField = UITextField()
    //전화번호
    let phoneImage = UIImageView(image: UIImage(systemName: "phone"))
    let phoneTextField = UITextField()
    //성별
    let genderImage = UIImageView(image: UIImage(systemName: "person.fill.questionmark"))
    //직책
    let jobImage = UIImageView(image: UIImage(systemName: "person.text.rectangle"))
    
    //세그먼트 컨트롤 값 저장 변수들
    var userGender: Int!
    var userJob: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpUIDeployment()
        
        self.idTextField.delegate = self
        self.passwordTextField.delegate = self
        self.pwAnswerTextField.delegate = self
        self.nameTextField.delegate = self
        self.birthTextField.delegate = self
        self.phoneTextField.delegate = self
        
    }
    //MARK: 액션 이벤트
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @objc func doJoin(_ sender: UIButton){
        //정보가 다 입력되어 있다면
        if self.idTextField.text?.isEmpty == false && self.passwordTextField.text?.isEmpty == false && self.pwLabel.text?.isEmpty == false && self.pwAnswerTextField.text?.isEmpty == false && self.nameTextField.text?.isEmpty == false && self.birthTextField.text?.isEmpty == false && self.phoneTextField.text?.isEmpty == false && self.userGender != nil && self.userJob != nil {
            let alert1 = UIAlertController(title: nil, message: "회원가입이 완료되었습니다.", preferredStyle: .alert)
            
            alert1.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                
                //파이어베이스로 넘겨주는 코드
                self.db.collection("users").document("\(self.idTextField.text!)").setData([
                    "id" : "\(self.idTextField.text!)",
                    "password" : "\(self.passwordTextField.text!)",
                    "question" : "\(self.pwLabel.text!)",
                    "answer" : "\(self.pwAnswerTextField.text!)",
                    "name" : "\(self.nameTextField.text!)",
                    "birth" : "\(self.birthTextField.text!)",
                    "phone" : "\(self.phoneTextField.text!)",
                    "gender" : "\(self.userGender!)",
                    "job" : "\(self.userJob!)"
                ]) { error in
                    if error == nil{
                        self.dismiss(animated: true)
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            })
            self.present(alert1, animated: true)
            
        } else {        //정보가 다 입력되지 않은 격우
            let alert2 = UIAlertController(title: "모든 정보가 입력되지않았습니다.", message: "다시 입력해주세요", preferredStyle: .alert)
            
            alert2.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert2, animated: true)
        }

    }
    
    @objc func doCheckId(_ sender: UIButton){
        //아이디 존재 여부 체크하는 코드 넣을 부분
        var dbResult: [String] = []
        
        db.collection("users").whereField("id", isEqualTo: self.idTextField.text!).getDocuments { (snapshot, error) in
                for doc in snapshot!.documents{
                    dbResult.append(doc.documentID)
                    print(dbResult)
                }
            
            if dbResult.isEmpty == true {
                let alert2 = UIAlertController(title: nil, message: "사용가능한 ID입니다.", preferredStyle: .alert)
                        
                alert2.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                    
                })
                        
                self.present(alert2, animated: true)
            } else {
                let alert1 = UIAlertController(title: nil, message: "이미 등록된 ID입니다.", preferredStyle: .alert)
                        
                alert1.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                    self.idTextField.text = nil
                })
                        
                self.present(alert1, animated: true)
            }
        }
    }
    
    @objc func doCheckPhone(_ sender: UIButton){
        var dbResult: [String] = []
        
        db.collection("users").whereField("phone", isEqualTo: self.phoneTextField.text!).getDocuments { (snapshot, error) in
                for doc in snapshot!.documents{
                    dbResult.append(doc.documentID)
                    print(dbResult)
                }
            
            if dbResult.isEmpty == true {
                let alert2 = UIAlertController(title: nil, message: "사용가능한 전화번호입니다.", preferredStyle: .alert)
                        
                alert2.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                    
                })
                        
                self.present(alert2, animated: true)
            } else {
                let alert1 = UIAlertController(title: "이미 등록된 전화번호입니다.", message: "아이디 찾기를 이용해주세요.", preferredStyle: .alert)
                        
                alert1.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                    self.phoneTextField.text = nil
                })
                        
                self.present(alert1, animated: true)
            }
        }
    }
    
    @objc func doselectedQuesetion(_ sender: UIButton){
        self.pwQuestionImage.tintColor = UIColor.black
        
        let pickerVC = PickerController()
        
        let alert = UIAlertController(title: nil, message: "비밀번호 질문", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default){ (_) in
            self.pwLabel.text = " \(pickerVC.selectedQuestion)"
            self.pwLabel.textColor = UIColor.black
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel){ (_) in
            if self.pwLabel.text == " Password Question"{
                self.pwQuestionImage.tintColor = UIColor.systemGray2
            } else {
                self.pwQuestionImage.tintColor = UIColor.black
            }
        })
        
        alert.setValue(pickerVC, forKey: "contentViewController")
        
        self.present(alert, animated: true)
    }
    
    @objc func changeGender(_ sender: UISegmentedControl){
        let value = sender.selectedSegmentIndex     //0이면 남자, 1이면 여자
        
        self.genderImage.tintColor = UIColor.black
        //성별 저장
        self.userGender = value
    }
    
    @objc func changeJob(_ sender: UISegmentedControl){
        let value = sender.selectedSegmentIndex     //0이면 사장, 1이면 직원, 2면 알바
        
        self.jobImage.tintColor = UIColor.black
        //직책저장
        self.userJob = value
    }
    
    //MARK: 텍스트 필드 델리게이트 메소드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.nameTextField:
            self.nameImage.tintColor = UIColor.black
        case self.birthTextField:
            self.birthImage.tintColor = UIColor.black
        case self.phoneTextField:
            self.phoneImage.tintColor = UIColor.black
        case self.idTextField:
            self.idImage.tintColor = UIColor.black
        case self.pwAnswerTextField:
            self.pwAnswerImage.tintColor = UIColor.black
        case self.passwordTextField:
            self.passwordImage.tintColor = UIColor.black
        default:
            ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.nameTextField:
            if self.nameTextField.text?.isEmpty == false {
                self.nameImage.tintColor = UIColor.black
            } else {
                self.nameImage.tintColor = UIColor.systemGray2
            }
        case self.birthTextField:
            if self.birthTextField.text?.isEmpty == false {
                self.birthImage.tintColor = UIColor.black
            } else {
                self.birthImage.tintColor = UIColor.systemGray2
            }
        case self.phoneTextField:
            if self.phoneTextField.text?.isEmpty == false {
                self.phoneImage.tintColor = UIColor.black
                
                let contents = textField.text! as NSString
                
                if contents.length != 11 {
                    let alert = UIAlertController(title: "11자리의 전화번호가 아닙니다.", message: "다시 입력해주세요.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                        self.phoneTextField.text = nil
                        self.phoneImage.tintColor = UIColor.systemGray2
                    })
                    
                    self.present(alert, animated: true)
                }
            } else {
                self.phoneImage.tintColor = UIColor.systemGray2
            }
        case self.idTextField:
            if self.idTextField.text?.isEmpty == false {
                self.idImage.tintColor = UIColor.black
                
                let contents = textField.text! as NSString
                
                if contents.length <= 1 {
                    let alert = UIAlertController(title: "아이디는 최소 2자리입니다.", message: "다시 입력해주세요.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                        self.idTextField.text = nil
                        self.idImage.tintColor = UIColor.systemGray2
                    })
                    
                    self.present(alert, animated: true)
                }
            } else {
                self.idImage.tintColor = UIColor.systemGray2
            }
        case self.pwAnswerTextField:
            if self.pwAnswerTextField.text?.isEmpty == false {
                self.pwAnswerImage.tintColor = UIColor.black
            } else {
                self.pwAnswerImage.tintColor = UIColor.systemGray2
            }
        case self.passwordTextField:
            if self.passwordTextField.text?.isEmpty == false {
                self.passwordImage.tintColor = UIColor.black
                
                let contents = textField.text! as NSString
                
                if contents.length <= 3 {
                    let alert = UIAlertController(title: "비밀번호는 최소 4자리입니다.", message: "다시 입력해주세요.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                        self.passwordTextField.text = nil
                        self.passwordImage.tintColor = UIColor.systemGray2
                    })
                    
                    self.present(alert, animated: true)
                }
            } else {
                self.passwordImage.tintColor = UIColor.systemGray2
            }
        default:
            ""
        }
    }
    
    //MARK: tap 제스쳐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        let pwButton = UIButton()
        
            //이미지
        pwQuestionImage.frame = CGRect(x: 70, y: 240, width: 30, height: 30)
        pwQuestionImage.tintColor = UIColor.systemGray2
        
            //레이블
        pwLabel.frame = CGRect(x: 110, y: 240, width: 150, height: 30)
        pwLabel.text = " Password Question"
        pwLabel.textColor = UIColor.systemGray3
        pwLabel.font = UIFont.init(name: "Chalkboard SE", size: 14)
        
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
        birthImage.frame = CGRect(x: 70, y: 360, width: 30, height: 30)
        birthImage.tintColor = UIColor.systemGray2
        
        birthTextField.frame = CGRect(x: 110, y: 360, width: 200, height: 30)
        birthTextField.keyboardType = .phonePad
        birthTextField.placeholder = "ex) 970101"
        birthTextField.borderStyle = .roundedRect
        birthTextField.layer.borderWidth = 1
        birthTextField.layer.borderColor = UIColor.systemGray2.cgColor
        birthTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(birthImage)
        self.view.addSubview(birthTextField)
        
        //전화번호
        let phoneButton = UIButton()
        
        phoneImage.frame = CGRect(x: 70, y: 400, width: 30, height: 30)
        phoneImage.tintColor = UIColor.systemGray2
        
        phoneTextField.frame = CGRect(x: 110, y: 400, width: 150, height: 30)
        phoneTextField.keyboardType = .phonePad
        phoneTextField.placeholder = "ex) 01012345678"
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor.systemGray2.cgColor
        phoneTextField.font = UIFont.init(name: "Chalkboard SE", size: 14)
        
        //버튼
        phoneButton.frame = CGRect(x: 270, y: 400, width: 40, height: 30)

        phoneButton.setTitle("확인", for: .normal)
        phoneButton.setTitleColor(UIColor.black, for: .normal)
        phoneButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 15)
        phoneButton.alpha = 0.7

        phoneButton.layer.cornerRadius = 5
        phoneButton.layer.borderWidth = 1
        phoneButton.layer.borderColor = UIColor.black.cgColor
        
        //MARK: 전화번호 확인 버튼 액션 이벤트
        phoneButton.addTarget(self, action: #selector(doCheckPhone(_:)), for: .touchUpInside)
        
        self.view.addSubview(phoneImage)
        self.view.addSubview(phoneTextField)
        self.view.addSubview(phoneButton)
        
        //성별
        let genderControl = UISegmentedControl(items: ["남자","여자"])
        
        genderImage.frame = CGRect(x: 70, y: 440, width: 30, height: 25)
        genderImage.tintColor = UIColor.systemGray2
        
        genderControl.frame = CGRect(x: 110, y: 440, width: 200, height: 25)
        
        //MARK: 성별 저장을 위한 값 변경 이벤트
        genderControl.addTarget(self, action: #selector(changeGender(_:)), for: .valueChanged)
            
        self.view.addSubview(genderImage)
        self.view.addSubview(genderControl)
        
        //직책
        let jobControl = UISegmentedControl(items: ["사장", "직원", "알바"])
        
        jobImage.frame = CGRect(x: 70, y: 475, width: 30, height: 25)
        jobImage.tintColor = UIColor.systemGray2
        
        jobControl.frame = CGRect(x: 110, y: 475, width: 200, height: 25)
        
        //MARK: 직책 저장을 위한 값 변경 이벤트
        jobControl.addTarget(self, action: #selector(changeJob(_:)), for: .valueChanged)
        
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
