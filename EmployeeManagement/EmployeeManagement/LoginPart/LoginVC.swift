//
//  LoginVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/09.
//

import UIKit
import SnapKit
import FirebaseFirestore

class LoginVC: UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //아이디
    let idImage = UIImageView(image: UIImage(systemName: "person.circle"))
    let idTextField = UITextField()
    
    //비밀번호
    let pwImage = UIImageView(image: UIImage(systemName: "lock.circle"))
    let pwTextField = UITextField()
    
    //아이디,비밀번호 찾기 버튼
    let find = UIButton()
    //회원가입 버튼
    let signUP = UIButton()
    //로그인 버튼
    let login = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI 배치
        uiDeployment()
        self.idTextField.delegate = self
        self.pwTextField.delegate = self
        
    }
    //MARK: 액션 메소드
    @objc func goFind(_ sender: UIButton){
        let nv = self.storyboard?.instantiateViewController(withIdentifier: "FindVC")
        nv?.modalPresentationStyle = .fullScreen
        
        self.present(nv!, animated: true)
        
    }
    
    @objc func goSignUp(_ sender: UIButton){
        let nv = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
        nv?.modalPresentationStyle = .fullScreen
        
        self.present(nv!, animated: true)
    }
    
    @objc func goMain(_ sender: UIButton){
        //documentID 저장
        var dbResult: [String] = []
        
        let query = db.collection("users").whereField("id", isEqualTo: self.idTextField.text!).whereField("password", isEqualTo: self.pwTextField.text!)
        
        query.getDocuments { (snapshot, error) in
                for doc in snapshot!.documents{
                    dbResult.append(doc.documentID)
                    self.appDelegate.idInfo = doc.data()["id"] as? String
                    self.appDelegate.jobInfo = doc.data()["job"] as? String
                    self.appDelegate.nameInfo = doc.data()["name"] as? String
                    self.appDelegate.phoneInfo = doc.data()["phone"] as? String
                    self.appDelegate.comment = doc.data()["comment"] as? String
                    self.appDelegate.profileState = doc.data()["profileImg"] as? Bool
                }
            if dbResult.isEmpty == true {
                let alert2 = UIAlertController(title: "Login Failed", message: "다시 입력해주세요.", preferredStyle: .alert)
                        
                alert2.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                    
                })
                self.present(alert2, animated: true)
            } else {
                let alert1 = UIAlertController(title: "Login Successful", message: "환영합니다.", preferredStyle: .alert)
                        
                alert1.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                    let nv = self.storyboard?.instantiateViewController(withIdentifier: "tapVC")
                    
                    self.navigationController?.pushViewController(nv!, animated: true)
                })
                self.present(alert1, animated: true)
            }
        }
    }
    
    //MARK: 택스트 필드 델리게이트 메소드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.idTextField{
            self.idImage.tintColor = UIColor.black
        } else if textField == self.pwTextField{
            self.pwImage.tintColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.idTextField{
            if self.idTextField.text?.isEmpty == false{
                self.idImage.tintColor = UIColor.black
            } else {
                self.idImage.tintColor = UIColor.systemGray3
            }
        } else if textField == self.pwTextField{
            if self.pwTextField.text?.isEmpty == false{
                self.pwImage.tintColor = UIColor.black
            } else {
                self.pwImage.tintColor = UIColor.systemGray3
            }
        }
    }
    
    //MARK: tap 제스쳐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: UI 배치(No Storyboard)
    func uiDeployment(){
        //로고 이미지
        let logo = UIImage(named: "management")
        let logoImage = UIImageView(image: logo)
        
        self.view.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-120)
            make.width.equalTo(140)
            make.height.equalTo(120)
        }
        
        //아이디
        idImage.tintColor = UIColor.systemGray3
        idTextField.placeholder = "Id"
        idTextField.borderStyle = .roundedRect
        idTextField.font = UIFont.init(name: "CookieRun", size: 15)
        
        self.view.addSubview(idImage)
        idImage.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading).offset(80)
            make.top.equalTo(logoImage.snp.bottom).offset(30)
            make.width.height.equalTo(30)
        }
        self.view.addSubview(idTextField)
        idTextField.snp.makeConstraints { make in
            make.leading.equalTo(idImage.snp.trailing).offset(10)
            make.trailing.equalTo(self.view.snp.trailing).offset(-80)
            make.top.equalTo(logoImage.snp.bottom).offset(30)
            make.height.equalTo(30)
        }
        
        //비밀번호
        pwImage.tintColor = UIColor.systemGray3
        pwTextField.placeholder = "Password"
        pwTextField.borderStyle = .roundedRect
        pwTextField.font = UIFont.init(name: "CookieRun", size: 15)
        
        self.view.addSubview(pwImage)
        pwImage.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading).offset(80)
            make.top.equalTo(self.idImage.snp.bottom).offset(20)
            make.width.height.equalTo(30)
        }
        self.view.addSubview(pwTextField)
        pwTextField.snp.makeConstraints { make in
            make.leading.equalTo(pwImage.snp.trailing).offset(10)
            make.trailing.equalTo(self.view.snp.trailing).offset(-80)
            make.top.equalTo(idTextField.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        
        //로그인 버튼
        login.setTitle("Login", for: .normal)
        login.setTitleColor(UIColor.black, for: .normal)
        login.titleLabel?.font = UIFont.init(name: "CookieRun", size: 17)
        login.alpha = 0.7
        login.layer.cornerRadius = 3
        login.layer.borderWidth = 2
        login.layer.borderColor = UIColor.systemGray.cgColor
        login.addTarget(self, action: #selector(goMain(_:)), for: .touchUpInside)
        
        self.view.addSubview(login)
        login.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading).offset(80)
            make.trailing.equalTo(self.view.snp.trailing).offset(-80)
            make.top.equalTo(self.pwTextField.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        
        //아이디,비밀번호 찾기 버튼
        find.setTitle("Find ID/Password", for: .normal)
        find.setTitleColor(UIColor.black, for: .normal)
        find.titleLabel?.font = UIFont.init(name: "CookieRun", size: 14)
        find.backgroundColor = .systemGray6
        find.alpha = 0.7
        find.layer.cornerRadius = 3
        find.addTarget(self, action: #selector(goFind(_:)), for: .touchUpInside)
        
        self.view.addSubview(find)
        find.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading).offset(80)
            make.trailing.equalTo(self.view.snp.centerX).offset(20)
            make.top.equalTo(self.login.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        //회원가입 버튼
        signUP.setTitle("Sign Up", for: .normal)
        signUP.setTitleColor(UIColor.black, for: .normal)
        signUP.backgroundColor = .systemGray6
        signUP.titleLabel?.font = UIFont.init(name: "CookieRun", size: 14)
        signUP.alpha = 0.7
        signUP.layer.cornerRadius = 3
        signUP.addTarget(self, action: #selector(goSignUp(_:)), for: .touchUpInside)
        
        self.view.addSubview(signUP)
        signUP.snp.makeConstraints { make in
            make.leading.equalTo(self.find.snp.trailing).offset(5)
            make.trailing.equalTo(self.view.snp.trailing).offset(-80)
            make.top.equalTo(self.login.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
    }

}
