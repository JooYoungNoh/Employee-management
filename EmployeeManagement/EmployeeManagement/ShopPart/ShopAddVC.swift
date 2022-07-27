//
//  ShopAddVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/17.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class ShopAddVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var imgExistence: Bool = false          //이미지 유무
    var companyExistence: String = ""       //회사 유무
    
    let background = UILabel()              //명함 배경
    
    let logoImage = UIImageView(image: UIImage(named: "logonil"))           //로고 이미지
    
    let companyTextfield = UITextField()    //회사 이름
    let ceoNameLabel = UILabel()            //대표자 이름
    let ceoPhoneLabel = UILabel()           //대표자 번호
    
    let businessType = UILabel()            //업종
    let businessButton = UIButton()         //업종 선택 버튼
    
    let registerButton = UIButton()         //등록 버튼
    

    override func viewDidLoad() {
        super.viewDidLoad()

        uiDeployment()
        
    }
    //MARK: Firestorage 메소드
    //이미지 업로드
    func uploadimage(img: UIImage){
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)!
        
        let filePath = "logoimage/\(self.companyTextfield.text!)"
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        storage.reference().child(filePath).putData(data, metadata: metaData) { (metaData,error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("성공")
            }
        }
    }
    
    //MARK: 이미지 피커 메소드
    // 이미지를 가져올 장소(?) 카메라 앨범 등 선택 메소드
    func imgPicker(_ source: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
        
    }
    //이미지 선택하면 호출될 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        self.logoImage.image = img
        
        //이미지 피커 컨트롤창 닫기
        picker.dismiss(animated: true)
    }
    
    //MARK: tap 제스쳐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @objc func selectBusinessType(_ sender: UIButton){
        let pickerVC = BusinessTypePicker()
        
        let alert = UIAlertController(title: "업종 선택", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default){ (_) in
            self.businessType.text = " \(pickerVC.selectedQuestion)"
            self.businessType.textColor = UIColor.black
            self.businessType.alpha = 1
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        alert.setValue(pickerVC, forKey: "contentViewController")
        
        self.present(alert, animated: true)
    }
    
    @objc func selectlogo(_ sender: UIButton){
        
        let alert = UIAlertController(title: nil, message: "선택해주세요", preferredStyle: .actionSheet)
        
        //카메라를 사용할 수 있으면 (시뮬레이터 불가)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default){(_) in
                self.imgPicker(.camera)
            })
        }
        
        //저장된 앨범을 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "앨범", style: .default){(_) in
                self.imgPicker(.savedPhotosAlbum)
            })
        }
        
        //포토 라이브러리를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default){(_) in
                self.imgPicker(.photoLibrary)
            })
        }
        
        //이미지 삭제
        alert.addAction(UIAlertAction(title: "로고 이미지 삭제", style: .default) { (_) in
            if self.logoImage.image == UIImage(named: "logonil") {
                let alert = UIAlertController(title: nil, message: "삭제할 로고 이미지가 없습니다.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else {
                self.logoImage.image = UIImage(named: "logonil")
            }
        })
        
        //취소 버튼 추가
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        //액션시트 창 실행
        self.present(alert, animated: true)
    }
    
    @objc func doregister(_ sender: UIButton){
        if self.companyTextfield.text == "" || self.businessType.text == " Select businessType" {
            let alert = UIAlertController(title: "모든 정보가 입력되지않았습니다.", message: "다시 입력해주세요", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
            
        } else{
            self.db.collection("shop").whereField("company", isEqualTo: self.companyTextfield.text!).getDocuments{ (snapshot,error) in
                for doc in snapshot!.documents{
                    self.companyExistence = doc.documentID
                }
                if self.companyExistence == self.companyTextfield.text! {
                    let alert2 = UIAlertController(title: "이미 등록된 회사입니다.", message: "다시 입력해주세요.", preferredStyle: .alert)
                    alert2.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert2, animated: true)
                } else {
                    if self.logoImage.image == UIImage(named: "logonil") {
                        let alert = UIAlertController(title: "로고 사진이 없습니다.", message: "그대로 진행하시겠습니까?", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                            self.imgExistence = false   // 이미지 여부
                            
                            let alert1 = UIAlertController(title: nil, message: "등록 완료", preferredStyle: .alert)
                            
                            alert1.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                                self.db.collection("shop").document("\(self.companyTextfield.text!)").setData([
                                    "company" : "\(self.companyTextfield.text!)",
                                    "name" : "\(self.appDelegate.nameInfo!)",
                                    "phone" : "\(self.appDelegate.phoneInfo!)",
                                    "businessType" : "\(self.businessType.text!)",
                                    "img" : self.imgExistence,
                                    "employeeCount" : 1
                                ]) { error in
                                    if error == nil{
                                        self.db.collection("shop").document("\(self.companyTextfield.text!)").collection("employeeControl").document("\(self.appDelegate.phoneInfo!)").setData([
                                            "phone" : "\(self.appDelegate.phoneInfo!)",
                                            "name" : "\(self.appDelegate.nameInfo!)",
                                            "comment" : "\(self.appDelegate.comment!)",
                                            "id" : "\(self.appDelegate.idInfo!)",
                                            "profileImg" : self.appDelegate.profileState!
                                            ])
                                    } else {
                                        print(error!.localizedDescription)
                                    }
                                }
                                
                                self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").document("\(self.companyTextfield.text!)").setData([
                                    "company" : "\(self.companyTextfield.text!)"
                                ])
                                
                                self.dismiss(animated: true)
                            })
                            self.present(alert1, animated: true)
                            
                        })
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        
                        self.present(alert, animated: true)
                        
                    } else {
                        self.imgExistence = true        //이미지 유무
                        
                        let alert1 = UIAlertController(title: nil, message: "등록 완료", preferredStyle: .alert)
                        
                        alert1.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                            
                            self.db.collection("shop").document("\(self.companyTextfield.text!)").setData([
                                "company" : "\(self.companyTextfield.text!)",
                                "name" : "\(self.appDelegate.nameInfo!)",
                                "phone" : "\(self.appDelegate.phoneInfo!)",
                                "businessType" : "\(self.businessType.text!)",
                                "img" : self.imgExistence,
                                "employeeCount" : 1
                            ]) { error in
                                if error == nil{
                                    self.db.collection("shop").document("\(self.companyTextfield.text!)").collection("employeeControl").document("\(self.appDelegate.phoneInfo!)").setData([
                                        "phone" : "\(self.appDelegate.phoneInfo!)",
                                        "name" : "\(self.appDelegate.nameInfo!)",
                                        "comment" : "\(self.appDelegate.comment!)",
                                        "id" : "\(self.appDelegate.idInfo!)",
                                        "profileImg" : self.appDelegate.profileState!
                                    ])
                                } else {
                                    print(error!.localizedDescription)
                                }
                            }
                            self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").document("\(self.companyTextfield.text!)").setData([
                                "company" : "\(self.companyTextfield.text!)"
                            ])
                            
                            self.uploadimage(img: self.logoImage.image!)
                            self.dismiss(animated: true)
                        })
                               
                        self.present(alert1, animated: true)
                    }
                }
            }
        }
    }
    
    //MARK: 메소드
    func uiDeployment(){
        //닫기 버튼 UI
        let closeButton = UIButton()
        
        closeButton.frame = CGRect(x: 20, y: 50, width: 80, height: 40)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        
        self.view.addSubview(closeButton)
        
        //화면 타이틀 UI
        let uiTitle = UILabel()
        
        uiTitle.frame = CGRect(x: self.view.frame.width / 2 - 100, y: 230, width: 200, height: 50)
        
        uiTitle.text = "Create Company"
        uiTitle.font = UIFont.init(name: "CookieRun", size: 25)
        uiTitle.textColor = UIColor.black
        
        self.view.addSubview(uiTitle)
        
        //명함 배경 UI
        self.background.frame = CGRect(x: 20, y: self.view.frame.height / 2 - 100, width: 350, height: 200)
        self.background.backgroundColor = UIColor.white
        self.background.layer.cornerRadius = 10
        self.background.layer.borderWidth = 2
        self.background.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(self.background)
        
        //회사 로고 이미지 뷰 UI
        self.logoImage.frame = CGRect(x: 40, y: self.view.frame.height / 2 - 80, width: 100, height: 100)
        
        //이미지 터치 시 이미지 변경
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectlogo(_:)))
        self.logoImage.addGestureRecognizer(tap)
        self.logoImage.isUserInteractionEnabled = true
        
        self.view.addSubview(self.logoImage)
        
        //회사명 텍스트 필드 UI
        self.companyTextfield.frame = CGRect(x: 160, y: self.view.frame.height / 2 - 80, width: 190, height: 30)
        self.companyTextfield.placeholder = "Company"
        self.companyTextfield.font = UIFont.init(name: "CookieRun", size: 14)
        
        self.companyTextfield.layer.borderWidth = 1
        self.companyTextfield.layer.borderColor = UIColor.systemGray2.cgColor
        self.companyTextfield.borderStyle = .roundedRect
        
        self.view.addSubview(self.companyTextfield)
        
        //대표자 레이블 UI
        self.ceoNameLabel.frame = CGRect(x: 160, y: self.view.frame.height / 2 - 40, width: 190, height: 30)
        self.ceoNameLabel.text = " \(self.appDelegate.nameInfo!)"
        self.ceoNameLabel.font = UIFont.init(name: "CookieRun", size: 14)
        
        self.ceoNameLabel.layer.borderWidth = 1
        self.ceoNameLabel.layer.borderColor = UIColor.systemGray2.cgColor
        
        self.view.addSubview(self.ceoNameLabel)
        
        //대표자 레이블 UI
        self.ceoPhoneLabel.frame = CGRect(x: 160, y: self.view.frame.height / 2, width: 190, height: 30)
        self.ceoPhoneLabel.text = " \(self.appDelegate.phoneInfo!)"
        self.ceoPhoneLabel.font = UIFont.init(name: "CookieRun", size: 14)
        
        self.ceoPhoneLabel.layer.borderWidth = 1
        self.ceoPhoneLabel.layer.borderColor = UIColor.systemGray2.cgColor
        
        self.view.addSubview(self.ceoPhoneLabel)
        
        //업종 레이블 UI
        self.businessType.frame = CGRect(x: 160, y: self.view.frame.height / 2 + 40, width: 140, height: 30)
        self.businessType.text = " Select businessType"
        self.businessType.font = UIFont.init(name: "CookieRun", size: 13)
        self.businessType.alpha = 0.7
        
        self.businessType.layer.borderWidth = 1
        self.businessType.layer.borderColor = UIColor.systemGray2.cgColor
        
        self.view.addSubview(self.businessType)
        
        //업종 선택 버튼 UI
        self.businessButton.frame = CGRect(x: 310, y: self.view.frame.height / 2 + 40, width: 40, height: 30)
        self.businessButton.setTitle("선택", for: .normal)
        self.businessButton.setTitleColor(UIColor.black, for: .normal)
        self.businessButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 14)
        
        self.businessButton.layer.cornerRadius = 5
        self.businessButton.layer.borderColor = UIColor.systemGray2.cgColor
        self.businessButton.layer.borderWidth = 1
        
        self.businessButton.addTarget(self, action: #selector(selectBusinessType(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.businessButton)
        
        //등록 버튼
        self.registerButton.frame = CGRect(x: self.view.frame.width / 2 - 60, y: self.view.frame.height / 2 + 130, width: 120, height: 40)
        self.registerButton.setTitle("register", for: .normal)
        self.registerButton.setTitleColor(UIColor.black, for: .normal)
        self.registerButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 16)
        self.registerButton.alpha = 0.7
        
        self.registerButton.layer.cornerRadius = 3
        self.registerButton.layer.borderColor = UIColor.systemGray.cgColor
        self.registerButton.layer.borderWidth = 2
        
        self.registerButton.addTarget(self, action: #selector(doregister(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.registerButton)
    }

}
