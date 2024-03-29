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
    var nameOnTable: String!
    var businessTypeOnTable: String!
    var phoneOnTable: String!
    var employeeCountOnTable: Int!
    var imgOnTable: Bool!
    
    var dbResultPhone: String!
    var dbResultImage: UIImage!
    
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
        //내비게이션 UI
        self.navigationItem.title = "Information"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        
        let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(doEdit(_:)))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        editButton.tintColor = UIColor.black
        
        
        uiDeployment()
        
        if self.imgOnTable == true {
            self.downloadimage(imgview: self.logoImage)
            self.imgExistence = true
        } else {
            self.logoImage.image = UIImage(named: "logonil")
            self.imgExistence = false
        }
        
        self.companyName.text = self.companyOnTable!
        self.ceoNameLabel.text = self.nameOnTable!
        self.ceoPhoneLabel.text = self.phoneOnTable!
        self.businessType.text = self.businessTypeOnTable!
        self.employeeNumber.text = "\(self.employeeCountOnTable!)명"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
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
        
        //이미지 피커 컨트롤창 닫기
        picker.dismiss(animated: true)
    }
    
    //MARK: 액션 메소드
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
                                        "name" : "\(self.appDelegate.nameInfo!)",
                                        "requestCompany" : "\(self.companyOnTable!)",
                                        "ceoPhone" : "\(self.phoneOnTable!)",
                                        "comment" : "\(self.appDelegate.comment!)",
                                        "id" : "\(self.appDelegate.idInfo!)",
                                        "profileImg" : self.appDelegate.profileState!
                                    ])
                                
                                    self.navigationController?.isNavigationBarHidden = false
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
    
    @objc func doEdit(_ sender: UIBarButtonItem){
        if self.ceoPhoneLabel.text! == self.appDelegate.phoneInfo! {          //본인 회사
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
                    if self.logoImage.image == UIImage(named: "logonil") {
                        let alert = UIAlertController(title: nil, message: "삭제할 로고 이미지가 없습니다.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    } else {
                        self.logoImage.image = UIImage(named: "logonil")
                        
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
                let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: "복구가 불가능합니다.", preferredStyle: .alert)
                
                alert.addTextField(){ (tf) in
                    tf.placeholder = "Write 'Delete'"
                    tf.font = UIFont(name: "CookieRun", size: 16)
                    tf.textColor = UIColor.red
                }
                
                alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                    if alert.textFields?[0].text == "Delete" {
                        let query2 =  self.db.collection("shop").document("\(self.companyOnTable!)")
                        
                        
                        // 내 정보에서  회사 삭제
                        query2.collection("employeeControl").getDocuments{ (snapshot, error) in
                            for doc in snapshot!.documents{
                                self.db.collection("users").document("\(doc.data()["id"] as! String)").collection("myCompany").document("\(self.companyOnTable!)").delete()
                            }
                        }
                        //직원 목록
                        query2.collection("employeeControl").getDocuments{ (snapshot, error) in
                            for doc in snapshot!.documents{
                                query2.collection("employeeControl").document("\(doc.documentID)").delete()
                            }
                        }
                        //가입 요청 목록
                        query2.collection("requestJoin").getDocuments{ (snapshot, error) in
                            for doc in snapshot!.documents{
                                query2.collection("requestJoin").document("\(doc.documentID)").delete()
                            }
                        }
                        //레시피 목록
                        query2.collection("recipe").getDocuments{ (snapshot, error) in
                            for doc in snapshot!.documents{
                                //레시피 이미지 삭제
                                self.deleteRecipeImage(docName: doc.documentID, imageList: doc.data()["imageList"] as! [String])
                                
                                query2.collection("recipe").document("\(doc.documentID)").delete()
                            }
                        }
                        //인수인계 목록
                        query2.collection("transition").getDocuments{ (snapshot, error) in
                            for doc in snapshot!.documents{
                                //인수인계 이미지 삭제
                                self.deleteRecipeImage(docName: doc.documentID, imageList: doc.data()["imageList"] as! [String])
                                
                                query2.collection("transition").document("\(doc.documentID)").delete()
                            }
                        }
                        
                        //공지 사항 목록 삭제
                        query2.collection("noticeList").getDocuments{ (snapshot, error) in
                            for doc in snapshot!.documents{
                                query2.collection("noticeList").document("\(doc.documentID)").delete()
                            }
                        }
                        //스케줄 목록 삭제
                        query2.collection("scheduleList").getDocuments{ (snapshot, error) in
                            for doc in snapshot!.documents{
                                query2.collection("scheduleList").document("\(doc.documentID)").collection("attendanceList").getDocuments { snapshot2, error2 in
                                    for doc2 in snapshot2!.documents {
                                        query2.collection("scheduleList").document("\(doc.documentID)").collection("attendanceList").document("\(doc2.documentID)").delete()
                                    }
                                    query2.collection("scheduleList").document("\(doc.documentID)").delete()
                                }
                            }
                        }
                        
                        query2.delete()
                        
                        if self.imgExistence == true {
                            self.deleteImage()
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let alert1 = UIAlertController(title: "입력이 정확하지않습니다.", message: "다시 시도해주세요.", preferredStyle: .alert)
                        
                        alert1.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert1, animated: true)
                    }
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            })
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            self.present(alert, animated: true)
        } else {                                                       //남 회사
            let alert = UIAlertController(title: nil, message: "다른 사람의 회사는 변경할 수 없습니다.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @objc func dosave(_ sender: UIButton){
        let alert = UIAlertController(title: "변경 사항이 저장됩니다.", message: "진행하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
            if self.logoImage.image == UIImage(named: "logonil") {
                if self.imgExistence == true {                  //이미지 없는데 true
                    //firestorage에 이미지 삭제 firestore에 img false로 변경
                    self.deleteImage()
                    self.db.collection("shop").document("\(self.companyOnTable!)").updateData(["img" : false])
                    self.imgExistence = false
                } else {                                        //이미지 없는데 false
                    //변경 없음
                }
            } else {
                if self.imgExistence == true {                  //이미지 있는데 true
                    //이미지가 변경된 경우
                    if self.logoImage.image != self.dbResultImage{
                        //첨 이미지 삭제 후 변경된 이미지 저장
                        self.deleteImage()
                        self.uploadimage(img: self.logoImage.image!)
                    } else {
                        //이미지 변경 없음(변화없음)
                    }
                } else {                                        //이미지 있는데 false
                    //firestorage에 이미지 추가 firestore에 img true로 변경
                    self.uploadimage(img: self.logoImage.image!)
                    self.db.collection("shop").document("\(self.companyOnTable!)").updateData(["img" : true])
                    self.imgExistence = true
                }
            }
            self.saveButton.isHidden = true
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
        
    }
    
    //MARK: FireStorage메소드
    //이미지 업로드
    func uploadimage(img: UIImage){
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)!
        
        let filePath = "logoimage/\(self.companyOnTable!)"
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
    
    //이미지 있을 떄 다운로드 메소드
    func downloadimage(imgview: UIImageView){
        storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/logoimage/\(self.companyOnTable!)").downloadURL { (url, error) in
            if error == nil && url != nil {
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                
                self.dbResultImage = image
                imgview.image = image
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //FireStorage에서 이미지 삭제 메소드
    func deleteImage() {
        storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/logoimage/\(self.companyOnTable!)").delete { (error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("이미지 삭제 성공")
            }
        }
    }
    
    //FireStorage에서 레시피 이미지 삭제 메소드
    func deleteRecipeImage(docName: String, imageList: [String]) {
        for i in imageList {
            storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/\(self.companyOnTable!)/\(docName)/\(i)").delete { (error) in
                if let error = error{
                    print(error.localizedDescription)
                } else {
                    print("이미지 삭제 성공")
                }
            }
        }
    }
    
    //MARK: 화면 메소드
    func uiDeployment(){
        //명함 배경 UI
        self.background.backgroundColor = UIColor.white
        self.background.layer.cornerRadius = 10
        self.background.layer.borderWidth = 2
        self.background.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(self.background)
        background.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading).offset(25)
            make.trailing.equalTo(self.view.snp.trailing).offset(-25)
            make.top.equalTo(self.view.snp.centerY).offset(-110)
            make.height.equalTo(220)
        }
        
        //회사 로고 이미지 뷰 UI
        self.logoImage.contentMode = .scaleToFill

        self.view.addSubview(self.logoImage)
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(self.background.snp.top).offset(20)
            make.leading.equalTo(self.background.snp.leading).offset(20)
            make.width.height.equalTo(100)
        }
        
        //회사명 UI
        self.companyName.font = UIFont.init(name: "CookieRun", size: 30)
        
        self.view.addSubview(self.companyName)
        companyName.snp.makeConstraints { make in
            make.top.equalTo(self.background.snp.top).offset(20)
            make.leading.equalTo(self.logoImage.snp.trailing).offset(20)
            make.trailing.equalTo(self.background.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
        
        //사원수 레이블 UI
        self.employeeNumber.textAlignment = .right
        self.employeeNumber.font = UIFont.init(name: "CookieRun", size: 15)
        
        self.view.addSubview(self.employeeNumber)
        employeeNumber.snp.makeConstraints { make in
            make.bottom.equalTo(self.background.snp.bottom).offset(-20)
            make.trailing.equalTo(self.background.snp.trailing).offset(-20)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        //업종 레이블 UI
        self.businessType.textAlignment = .right
        self.businessType.font = UIFont.init(name: "CookieRun", size: 15)
        
        self.view.addSubview(self.businessType)
        businessType.snp.makeConstraints { make in
            make.bottom.equalTo(self.background.snp.bottom).offset(-20)
            make.leading.equalTo(self.companyName.snp.leading)
            make.trailing.equalTo(self.employeeNumber.snp.leading).offset(-5)
            make.height.equalTo(20)
        }
        
        //전화번호 레이블 UI
        self.ceoPhoneLabel.font = UIFont.init(name: "CookieRun", size: 15)
        self.ceoPhoneLabel.textAlignment = .right
        
        self.view.addSubview(self.ceoPhoneLabel)
        ceoPhoneLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.employeeNumber.snp.top).offset(-5)
            make.leading.equalTo(self.companyName.snp.leading)
            make.trailing.equalTo(self.background.snp.trailing).offset(-20)
            make.height.equalTo(30)
        }
        
        //대표자 레이블 UI
        self.ceoNameLabel.font = UIFont.init(name: "CookieRun", size: 25)
        self.ceoNameLabel.textAlignment = .right
        
        
        self.view.addSubview(self.ceoNameLabel)
        ceoNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.ceoPhoneLabel.snp.top).offset(-5)
            make.leading.equalTo(self.companyName.snp.leading)
            make.trailing.equalTo(self.background.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }

        //가입 신청 버튼
        self.requestButton.setTitle("Request Join", for: .normal)
        self.requestButton.setTitleColor(UIColor.black, for: .normal)
        self.requestButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 16)
        self.requestButton.alpha = 0.7
        
        self.requestButton.layer.cornerRadius = 3
        self.requestButton.layer.borderColor = UIColor.systemGray.cgColor
        self.requestButton.layer.borderWidth = 2
        
        self.requestButton.addTarget(self, action: #selector(doRequestJoin(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.requestButton)
        requestButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.background.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
        //저장 버튼 UI
        self.saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.black, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 16)
        self.saveButton.isHidden = true
        self.saveButton.alpha = 0.7
        
        self.saveButton.layer.cornerRadius = 3
        self.saveButton.layer.borderColor = UIColor.systemGray.cgColor
        self.saveButton.layer.borderWidth = 2
        
        self.saveButton.addTarget(self, action: #selector(dosave(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.saveButton)
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(requestButton.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
    }

}
