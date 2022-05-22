//
//  ShopInformationVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/19.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class ShopInformationVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var companyOnTable: String!
    var dbResultPhone: String!
    
    var imgExistence: Bool!                 //이미지 유무
    
    let saveButton = UIButton()             //저장 버튼
    
    let background = UILabel()              //명함 배경
    
    let logoImage = UIImageView()           //로고 이미지
    
    let companyName = UILabel()             //회사 이름
    let ceoNameLabel = UILabel()            //대표자 이름
    let ceoPhoneLabel = UILabel()           //대표자 번호
    
    let businessType = UILabel()            //업종
    let employeeNumber = UILabel()          //사원수
    
    let requestButton = UIButton()          //등록 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.db.collection("shop").document("\(self.companyOnTable!)").getDocument { (snapshot, error) in
            if error == nil && snapshot != nil {
                self.companyName.text = self.companyOnTable
                self.ceoNameLabel.text = snapshot?.data()?["name"] as? String
                self.ceoPhoneLabel.text = snapshot?.data()?["phone"] as? String
                self.businessType.text = snapshot?.data()?["businessType"] as? String
                self.employeeNumber.text = "\(snapshot?.data()?["employeeCount"] as! Int)명"
                
                if (snapshot?.data()?["img"] as? Bool) == true {
                    self.downloadimage(imgview: self.logoImage)
                } else {
                    self.logoImage.image = nil
                }
                
            } else {
                print(error!.localizedDescription)
            }
            
        }

        uiDeployment()
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
        
        //저장 버튼 보이게 하기
        self.saveButton.isHidden = false
        //저장버튼 누르면 경우 메모장 보기
        
        //이미지 피커 컨트롤창 닫기
        picker.dismiss(animated: true)
    }
    
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doRequestJoin(_ sender: UIButton){
        
        let query = self.db.collection("shop").document("\(self.companyOnTable!)")
            
        query.collection("employeeControl").document("\(self.appDelegate.phoneInfo!)").getDocument { (snapshot, error) in
            if error == nil && snapshot != nil {
                //이미 회사에 가입되어 있을 경우
                if self.appDelegate.phoneInfo! == snapshot?.data()?["phone"] as? String {
                    let alert = UIAlertController(title: nil, message: "이미 가입되어있습니다.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    self.present(alert, animated: true)
                } else {
                    print("성공")
                    //가입은 되어있지 않은데 신청은 되있는 상태
                    query.collection("requestJoin").document("\(self.appDelegate.phoneInfo!)").getDocument { (snapshot,error) in
                        if error == nil && snapshot != nil {
                            
                            if self.appDelegate.phoneInfo! == snapshot?.data()?["phone"] as? String {
                                let alert = UIAlertController(title: nil, message: "이미 신청되어있습니다.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "OK", style: .default))
                                
                                self.present(alert, animated: true)
                            } else {
                                //둘다 안된 상태
                                let alert1 = UIAlertController(title: "가입 신청 완료되었습니다.", message: "CEO가 승인하면 가입됩니다.", preferredStyle: .alert)
                                
                                alert1.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                                    query.collection("requestJoin").document("\(self.appDelegate.phoneInfo!)").setData([
                                        "phone" : "\(self.appDelegate.phoneInfo!)",
                                        "name" : "\(self.appDelegate.nameInfo!)"
                                    ])
                                
                                    self.navigationController?.popViewController(animated: true)
                                
                                })
                                self.present(alert1, animated: true)
                            }
                        } else {
                            print(error!.localizedDescription)
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    
    @objc func doEdit(_ sender: UIButton){
        let alert = UIAlertController(title: nil, message: "선택해주세요.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "로고 변경", style: .default) { (_) in
            
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
                if self.logoImage.image == nil {
                    let alert = UIAlertController(title: nil, message: "삭제할 로고 이미지가 없습니다.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } else {
                    self.logoImage.image = nil
                    
                    //저장버튼 활성화
                    self.saveButton.isHidden = false
                    //파이어스토리지에 저장된 이미지도 삭제해야됨
                }
            })
            
            //취소 버튼 추가
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            //액션시트 창 실행
            self.present(alert, animated: true)
            
        })
        
        alert.addAction(UIAlertAction(title: "회사 삭제", style: .default) { (_) in
            
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    //MARK: 메소드
    //이미지 다운로드 메소드
    func downloadimage(imgview: UIImageView){
        storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/\(self.companyOnTable!)").downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            
            imgview.image = image
        }
    }
    
    func uiDeployment(){
        //닫기 버튼 UI
        let backButton = UIButton()
        
        backButton.frame = CGRect(x: 20, y: 50, width: 60, height: 40)
        
        backButton.setTitle("< Back", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 20)
        
        backButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        
        //저장 버튼 UI
        self.saveButton.frame = CGRect(x: 260, y: 50, width: 60, height: 40)
        
        self.saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.black, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 20)
        self.saveButton.isHidden = true
        
        self.view.addSubview(self.saveButton)
        
        //편집 버튼 UI
        let editButton = UIButton()
        
        editButton.frame = CGRect(x: 320, y: 50, width: 60, height: 40)
        
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(UIColor.black, for: .normal)
        editButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 20)
        
        editButton.addTarget(self, action: #selector(doEdit(_:)), for: .touchUpInside)
        
        self.view.addSubview(editButton)
        
        //화면 타이틀 UI
        let uiTitle = UILabel()
        
        uiTitle.frame = CGRect(x: self.view.frame.width / 2 - 130, y: 230, width: 260, height: 50)
        
        uiTitle.text = "Company Information"
        uiTitle.font = UIFont.init(name: "Chalkboard SE", size: 25)
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
        self.logoImage.backgroundColor = UIColor.systemGray3
        
        self.view.addSubview(self.logoImage)
        
        //회사명 UI
        self.companyName.frame = CGRect(x: 160, y: self.view.frame.height / 2 - 90, width: 190, height: 50)
        
        //self.companyName.text = "네이버"
        //self.companyName.textAlignment = .right
        self.companyName.font = UIFont.init(name: "Chalkboard SE", size: 30)
        
        self.view.addSubview(self.companyName)
        
        //대표자 레이블 UI
        self.ceoNameLabel.frame = CGRect(x: 160, y: self.view.frame.height / 2 - 10, width: 190, height: 40)
       // self.ceoNameLabel.text = "CEO 노주영"
        self.ceoNameLabel.font = UIFont.init(name: "Chalkboard SE", size: 25)
        self.ceoNameLabel.textAlignment = .right
        
        
        self.view.addSubview(self.ceoNameLabel)
        
        //전화번호 레이블 UI
        self.ceoPhoneLabel.frame = CGRect(x: 160, y: self.view.frame.height / 2 + 35, width: 190, height: 20)
      //  self.ceoPhoneLabel.text = "01011111111"
        self.ceoPhoneLabel.font = UIFont.init(name: "Chalkboard SE", size: 15)
        self.ceoPhoneLabel.textAlignment = .right
        
        self.view.addSubview(self.ceoPhoneLabel)
        
        //업종 레이블 UI
        self.businessType.frame = CGRect(x: 140, y: self.view.frame.height / 2 + 50, width: 170, height: 30)
      //  self.businessType.text = "서비스업"
        self.businessType.textAlignment = .right
        self.businessType.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(self.businessType)
        
        //사원수 레이블 UI
        self.employeeNumber.frame = CGRect(x: 310, y: self.view.frame.height / 2 + 50, width: 40, height: 30)
        
       // self.employeeNumber.text = "1명"
        self.employeeNumber.textAlignment = .right
        self.employeeNumber.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(self.employeeNumber)

        //가입 신청 버튼
        self.requestButton.frame = CGRect(x: self.view.frame.width / 2 - 60, y: self.view.frame.height / 2 + 130, width: 120, height: 40)
        self.requestButton.setTitle("Request Join", for: .normal)
        self.requestButton.setTitleColor(UIColor.black, for: .normal)
        self.requestButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 16)
        self.requestButton.alpha = 0.7
        
        self.requestButton.layer.cornerRadius = 3
        self.requestButton.layer.borderColor = UIColor.systemGray.cgColor
        self.requestButton.layer.borderWidth = 2
        
        self.requestButton.addTarget(self, action: #selector(doRequestJoin(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.requestButton)
    }

}