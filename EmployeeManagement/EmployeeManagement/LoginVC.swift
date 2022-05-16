//
//  LoginVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/09.
//

import UIKit
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
                    self.appDelegate.idInfo = doc.data()["id"] as! String
                    self.appDelegate.jobInfo = doc.data()["job"] as! String
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
        
        logoImage.frame = CGRect(x: self.view.frame.width/2 - 70, y: 200, width: 140, height: 120)
        
        self.view.addSubview(logoImage)
        
        //아이디
        idImage.frame = CGRect(x: 80, y: 350, width: 30, height: 30)
        idImage.tintColor = UIColor.systemGray3
        idTextField.frame = CGRect(x: 120, y: 350, width: 180, height: 30)
        idTextField.placeholder = "Id"
        idTextField.borderStyle = .roundedRect
        idTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(idImage)
        self.view.addSubview(idTextField)
        
        //비밀번호
        pwImage.frame = CGRect(x: 80, y: 400, width: 30, height: 30)
        pwImage.tintColor = UIColor.systemGray3
        
        pwTextField.frame = CGRect(x: 120, y: 400, width: 180, height: 30)
        pwTextField.placeholder = "Password"
        pwTextField.borderStyle = .roundedRect
        pwTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(pwImage)
        self.view.addSubview(pwTextField)
        
        //로그인 버튼
        login.frame = CGRect(x: 80, y: 450, width: 220, height: 40)
        
        login.setTitle("Login", for: .normal)
        login.setTitleColor(UIColor.black, for: .normal)
        login.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 16)
        login.alpha = 0.7
        
        login.layer.cornerRadius = 3
        login.layer.borderWidth = 2
        login.layer.borderColor = UIColor.systemGray.cgColor
        
        //MARK: 로그인 버튼 이벤트
        login.addTarget(self, action: #selector(goMain(_:)), for: .touchUpInside)
        
        self.view.addSubview(login)
        
        //아이디,비밀번호 찾기 버튼
        find.frame = CGRect(x: 87, y: 495, width: 140, height: 30)
        
        find.setTitle("Find ID/Find Password", for: .normal)
        find.setTitleColor(UIColor.black, for: .normal)
        find.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 13)
        find.alpha = 0.7
        
        //MARK: 아이디 비번 찾기 버튼 이벤트
        find.addTarget(self, action: #selector(goFind(_:)), for: .touchUpInside)
        
        self.view.addSubview(find)
        
        //회원가입 버튼
        signUP.frame = CGRect(x: 229, y: 495, width: 64, height: 30)
        
        signUP.setTitle("Sign Up", for: .normal)
        signUP.setTitleColor(UIColor.black, for: .normal)
        signUP.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 13)
        signUP.alpha = 0.7
        
        //MARK: 회원가입 버튼 이벤트
        signUP.addTarget(self, action: #selector(goSignUp(_:)), for: .touchUpInside)
        
        self.view.addSubview(signUP)
    }

}
