//
//  FindIDVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/10.
//

import UIKit
import FirebaseFirestore

class FindVC: UIViewController, UITextFieldDelegate {
    
    let db =  Firestore.firestore()
    
    //이름
    let nameImage = UIImageView(image: UIImage(systemName: "face.smiling"))
    let nameTextField = UITextField()
    //생년월일
    let birthImage = UIImageView(image: UIImage(systemName: "calendar"))
    let birthTextField = UITextField()
    //전화번호
    let phoneImage = UIImageView(image: UIImage(systemName: "phone"))
    let phoneTextField = UITextField()
    //아이디
    let idImage = UIImageView(image: UIImage(systemName: "person.circle"))
    let idTextField = UITextField()
    //비밀번호 질문 창
    let pwQuestionImage = UIImageView(image: UIImage(systemName: "questionmark.circle"))
    let pwLabel = UILabel()
    //비밀번호 질문 답변 창
    let pwAnswerImage = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
    let pwAnswerTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        idUIDeployment()
        passwordUIDeployment()
        
        //델리게이트
        self.nameTextField.delegate = self
        self.birthTextField.delegate = self
        self.phoneTextField.delegate = self
        self.idTextField.delegate = self
        self.pwAnswerTextField.delegate = self
    }
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @objc func doIdFind(_ sender: UIButton){
        var dbResultID: String = ""       //문서 아이디 저장
        
        let query = db.collection("users").whereField("name", isEqualTo: self.nameTextField.text!).whereField("birth", isEqualTo: self.birthTextField.text!).whereField("phone", isEqualTo: self.phoneTextField.text!)
        
        query.getDocuments { (snapshot, error) in
            for doc in snapshot!.documents{
                dbResultID = doc.documentID
                print(dbResultID)
            }
            
            if self.nameTextField.text?.isEmpty == false && self.birthTextField.text?.isEmpty == false && self.phoneTextField.text?.isEmpty == false {
                if dbResultID != "" {
                    let alert1 = UIAlertController(title: "아이디", message: "\(dbResultID)", preferredStyle: .alert)
                    
                    alert1.addAction(UIAlertAction(title: "OK", style: .cancel){ (_) in
                        self.idTextField.text = dbResultID
                        self.idImage.tintColor = UIColor.black
                    })
                    
                    self.present(alert1, animated: true)
                } else {
                
                    let alert2 = UIAlertController(title: "정보가 올바르지 않거나 찾지 못하였습니다.", message: nil, preferredStyle: .alert)
                
                    alert2.addAction(UIAlertAction(title: "OK", style: .cancel){ (_) in
                    })
                
                    self.present(alert2, animated: true)
                }
            } else {
                let alert3 = UIAlertController(title: "모든 정보가 입력되지않았습니다.", message: "다시 입력해주세요", preferredStyle: .alert)
            
                alert3.addAction(UIAlertAction(title: "OK", style: .cancel))
            
                self.present(alert3, animated: true)
            }
        }
    }
    
    @objc func doPasswordFind(_ sender: UIButton){
        var dbResultPW: String = ""
        
        let query = self.db.collection("users").whereField("id", isEqualTo: self.idTextField.text!).whereField("question", isEqualTo: self.pwLabel.text!).whereField("answer", isEqualTo: self.pwAnswerTextField.text!)
        
        query.getDocuments{ (snapshot, error) in
            for doc in snapshot!.documents{
                dbResultPW = doc.data()["password"] as! String
            }

            if self.idTextField.text?.isEmpty == false && self.pwLabel.text?.isEmpty == false && self.pwAnswerTextField.text?.isEmpty == false {
                if dbResultPW != "" {
                    let alert1 = UIAlertController(title: "비밀번호", message: "\(dbResultPW)", preferredStyle: .alert)
                    
                    alert1.addAction(UIAlertAction(title: "OK", style: .cancel))
                    
                    self.present(alert1, animated: true)
                } else {
                
                    let alert2 = UIAlertController(title: "정보가 올바르지 않거나 찾지 못하였습니다.", message: nil, preferredStyle: .alert)
                
                    alert2.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert2, animated: true)
                }
            } else {
                let alert3 = UIAlertController(title: "모든 정보가 입력되지않았습니다.", message: "다시 입력해주세요", preferredStyle: .alert)
            
                alert3.addAction(UIAlertAction(title: "OK", style: .cancel))
            
                self.present(alert3, animated: true)
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
        alert.addAction(UIAlertAction(title: "취소", style: .cancel){(_) in
            if self.pwLabel.text == " Password Question"{
                self.pwQuestionImage.tintColor = UIColor.systemGray2
            } else {
                self.pwQuestionImage.tintColor = UIColor.black
            }
        })
        
        alert.setValue(pickerVC, forKey: "contentViewController")
        
        self.present(alert, animated: true)
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
            } else {
                self.phoneImage.tintColor = UIColor.systemGray2
            }
        case self.idTextField:
            if self.idTextField.text?.isEmpty == false {
                self.idImage.tintColor = UIColor.black
            } else {
                self.idImage.tintColor = UIColor.systemGray2
            }
        case self.pwAnswerTextField:
            if self.pwAnswerTextField.text?.isEmpty == false {
                self.pwAnswerImage.tintColor = UIColor.black
            } else {
                self.pwAnswerImage.tintColor = UIColor.systemGray2
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
    func idUIDeployment(){
        //닫기 버튼
        let closeButton = UIButton()
        
        closeButton.frame = CGRect(x: 20, y: 50, width: 80, height: 40)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        
        self.view.addSubview(closeButton)
        
        //아이디 찾기 레이블
        let findID = UILabel()
        
        findID.frame = CGRect(x: self.view.frame.width/2 - 80, y: 90, width: 160, height: 50)
        findID.text = "Find ID"
        findID.textColor = UIColor.black
        findID.font = UIFont.init(name: "CookieRun", size: 30)
        findID.textAlignment = .center
        
        self.view.addSubview(findID)
        
        //이름
        nameImage.frame = CGRect(x: 70, y: 150, width: 30, height: 30)
        nameImage.tintColor = UIColor.systemGray2
        
        nameTextField.frame = CGRect(x: 110, y: 150, width: 200, height: 30)
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.systemGray2.cgColor
        nameTextField.font = UIFont.init(name: "CookieRun", size: 15)
        
        self.view.addSubview(nameImage)
        self.view.addSubview(nameTextField)
        
        //생년월일
        birthImage.frame = CGRect(x: 70, y: 190, width: 30, height: 30)
        birthImage.tintColor = UIColor.systemGray2
        
        birthTextField.frame = CGRect(x: 110, y: 190, width: 200, height: 30)
        birthTextField.keyboardType = .phonePad
        birthTextField.placeholder = "ex) 970101"
        birthTextField.borderStyle = .roundedRect
        birthTextField.layer.borderWidth = 1
        birthTextField.layer.borderColor = UIColor.systemGray2.cgColor
        birthTextField.font = UIFont.init(name: "CookieRun", size: 15)
        
        self.view.addSubview(birthImage)
        self.view.addSubview(birthTextField)
        
        //전화번호
        phoneImage.frame = CGRect(x: 70, y: 230, width: 30, height: 30)
        phoneImage.tintColor = UIColor.systemGray2
        
        phoneTextField.frame = CGRect(x: 110, y: 230, width: 200, height: 30)
        phoneTextField.keyboardType = .phonePad
        phoneTextField.placeholder = "ex) 01000000000"
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor.systemGray2.cgColor
        phoneTextField.font = UIFont.init(name: "CookieRun", size: 15)
        
        self.view.addSubview(phoneImage)
        self.view.addSubview(phoneTextField)
        
        //아이디 찾기 버튼
        let findIdButton = UIButton()
        
        findIdButton.frame = CGRect(x: 260, y: 270, width: 50, height: 30)
        
        findIdButton.setTitle("Find", for: .normal)
        findIdButton.setTitleColor(UIColor.black, for: .normal)
        findIdButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 15)
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
        findPW.font = UIFont.init(name: "CookieRun", size: 30)
        findPW.textAlignment = .center
        
        self.view.addSubview(findPW)
        
        //아이디
        idImage.frame = CGRect(x: 70, y: 405, width: 30, height: 30)
        idImage.tintColor = UIColor.systemGray2
        
        idTextField.frame = CGRect(x: 110, y: 405, width: 200, height: 30)
        idTextField.placeholder = "id"
        idTextField.borderStyle = .roundedRect
        idTextField.layer.borderWidth = 1
        idTextField.layer.borderColor = UIColor.systemGray2.cgColor
        idTextField.font = UIFont.init(name: "CookieRun", size: 15)
        
        self.view.addSubview(idImage)
        self.view.addSubview(idTextField)
        
        //비밀번호 질문 창
        let pwButton = UIButton()
        
            //이미지
        pwQuestionImage.frame = CGRect(x: 70, y: 445, width: 30, height: 30)
        pwQuestionImage.tintColor = UIColor.systemGray2
        
            //레이블
        pwLabel.frame = CGRect(x: 110, y: 445, width: 150, height: 30)
        pwLabel.text = " Password Question"
        pwLabel.textColor = UIColor.systemGray2
        pwLabel.font = UIFont.init(name: "CookieRun", size: 14)
        
        pwLabel.layer.borderWidth = 1
        pwLabel.layer.borderColor = UIColor.systemGray2.cgColor
        
            //버튼
        pwButton.frame = CGRect(x: 270, y: 445, width: 40, height: 30)
        
        pwButton.setTitle("선택", for: .normal)
        pwButton.setTitleColor(UIColor.black, for: .normal)
        pwButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 15)
        pwButton.alpha = 0.7
        
        pwButton.layer.cornerRadius = 5
        pwButton.layer.borderWidth = 1
        pwButton.layer.borderColor = UIColor.black.cgColor
        
        pwButton.addTarget(self, action: #selector(doselectedQuesetion(_:)), for: .touchUpInside)
        
        self.view.addSubview(pwQuestionImage)
        self.view.addSubview(pwLabel)
        self.view.addSubview(pwButton)
        
        //비밀번호 질문 답변 창
        pwAnswerImage.frame = CGRect(x: 70, y: 485, width: 30, height: 30)
        pwAnswerImage.tintColor = UIColor.systemGray2
        
        pwAnswerTextField.frame = CGRect(x: 110, y: 485, width: 200, height: 30)
        pwAnswerTextField.placeholder = "Password Qusetion Answer"
        pwAnswerTextField.borderStyle = .roundedRect
        pwAnswerTextField.layer.borderWidth = 1
        pwAnswerTextField.layer.borderColor = UIColor.systemGray2.cgColor
        pwAnswerTextField.font = UIFont.init(name: "CookieRun", size: 14)
        
        self.view.addSubview(pwAnswerImage)
        self.view.addSubview(pwAnswerTextField)
        
        //비밀번호 찾기 버튼
        let findpwButton = UIButton()
        
        findpwButton.frame = CGRect(x: 260, y: 525, width: 50, height: 30)
        
        findpwButton.setTitle("Find", for: .normal)
        findpwButton.setTitleColor(UIColor.black, for: .normal)
        findpwButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 15)
        findpwButton.alpha = 0.7
        
        findpwButton.layer.cornerRadius = 5
        findpwButton.layer.borderWidth = 1
        findpwButton.layer.borderColor = UIColor.black.cgColor
        
        findpwButton.addTarget(self, action: #selector(doPasswordFind(_:)), for: .touchUpInside)
        
        self.view.addSubview(findpwButton)
        
    }
}
