//
//  ProfileVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/10.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class MyProfileVM {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var changeImageStateCompany: [String] = []
    var dbmyCompany: [String] = []              //내 회사
    var dbmyCompanyLogo: Bool = false           //회사 로고 유무
    
    //MARK: 회사 컬렉션 뷰
    //회사 찾기
    func findMyCompany(completion: @escaping([String]) -> ()) {
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").getDocuments { (snapshot, error) in
            if error == nil {
                for doc in snapshot!.documents{
                    self.dbmyCompany.append(doc.documentID)
                }
                completion(self.dbmyCompany)
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //회사 이미지 다운로드
    func companyDownloadimage(imgView: UIImageView, company: String){
        self.db.collection("shop").document("\(company)").getDocument { snapshot, error in
            self.dbmyCompanyLogo = snapshot!.data()!["img"] as! Bool
            
            if self.dbmyCompanyLogo == true{
                self.storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/\(company)").downloadURL { (url, error) in
                    if error == nil && url != nil {
                        let data = NSData(contentsOf: url!)
                        let dbImage = UIImage(data: data! as Data)
                        
                        imgView.image = dbImage
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            } else {
                imgView.image = UIImage(named: "logonil")
            }
        }
    }
    //MARK: 프로필 이미지
    //프로필 이미지 삭제
    func imageDelete(imgView: UIImageView) -> UIAlertController {
        if imgView.image == UIImage(named: "account") {
            let alert3 = UIAlertController(title: nil, message: "삭제할 로고 이미지가 없습니다", preferredStyle: .alert)
            
            alert3.addAction(UIAlertAction(title: "OK", style: .default))
            return alert3
        } else {
            let alert4 = UIAlertController(title: "프로필 이미지가 삭제됩니다", message: "변경사항을 저장해주세요", preferredStyle: .alert)
            
            alert4.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                imgView.image = UIImage(named: "account")
            })
            return alert4
        }
        

    }
    
    //변경 사항 저장 메소드
    func changeValueSave(imgView: UIImageView, tableImg: UIImage){
        if imgView.image == UIImage(named: "account") {
            if self.appDelegate.profileState == true {                  //이미지 없는데 true
                //스토리지에서 삭제
                self.deleteImage()
                //스토어에서 이미지 상태 변경
                self.db.collection("users").document("\(self.appDelegate.idInfo!)").updateData(["profileImg" : false])
                self.appDelegate.profileState = false
                //회사마다 이미지 유무 바꾸기
                self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").getDocuments { (snapshot, error) in
                    if error == nil {
                        for doc in snapshot!.documents{
                            self.changeImageStateCompany.append(doc.documentID)
                        }
                        for dic in self.changeImageStateCompany{
                            self.db.collection("shop").document("\(dic)").collection("employeeControl").document("\(self.appDelegate.phoneInfo!)").updateData(["profileImg" : false])
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            } else {                                        //이미지 없는데 false
                //변경 없음
            }
        } else {
            if self.appDelegate.profileState == true {                  //이미지 있는데 true
                //이미지가 변경된 경우
                if imgView.image != tableImg{
                    //첨 이미지 삭제 후 변경된 이미지 저장
                    self.deleteImage()
                    self.uploadimage(img: imgView.image!)
                } else {
                    //이미지 변경 없음(변화없음)
                }
            } else {                                        //이미지 있는데 false
                //firestorage에 이미지 추가 firestore에 img true로 변경
                self.uploadimage(img: imgView.image!)
                self.db.collection("users").document("\(self.appDelegate.idInfo!)").updateData(["profileImg" : true])
                self.appDelegate.profileState = true
                //회사마다 이미지 유무 바꾸기
                self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").getDocuments { (snapshot, error) in
                    if error == nil {
                        for doc in snapshot!.documents{
                            self.changeImageStateCompany.append(doc.documentID)
                        }
                        for dic in self.changeImageStateCompany{
                            self.db.collection("shop").document("\(dic)").collection("employeeControl").document("\(self.appDelegate.phoneInfo!)").updateData(["profileImg" : true])
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            }
        }
        
    }
    
    //이미지 업로드
    func uploadimage(img: UIImage){
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)!
        
        let filePath = self.appDelegate.phoneInfo!
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
    
    //FireStorage에서 이미지 삭제 메소드
    func deleteImage() {
        storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/\(self.appDelegate.phoneInfo!)").delete { (error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("이미지 삭제 성공")
            }
        }
    }
    
    //MARK: 내 상태메시지 변경
    func changeCommentSave(commentTF: UITextView, commentLabel: UILabel){
        if commentTF.text != commentLabel.text {
            commentLabel.text = commentTF.text
            self.appDelegate.comment = commentTF.text
            //스토어에서 코멘트 변경
            self.db.collection("users").document("\(self.appDelegate.idInfo!)").updateData(["comment" : "\(String(describing: commentTF.text!))"])
            
            //회사마다 코멘트 유무 바꾸기
            self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").getDocuments { (snapshot, error) in
                if error == nil {
                    for doc in snapshot!.documents{
                        self.changeImageStateCompany.append(doc.documentID)
                    }
                    for dic in self.changeImageStateCompany{
                        self.db.collection("shop").document("\(dic)").collection("employeeControl").document("\(self.appDelegate.phoneInfo!)").updateData(["comment" : "\(String(describing: commentTF.text!))"])
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    //텍스트 필드
    func changeMessage(textView: UITextView, countLabel: UILabel, commentLabel: UILabel, saveButton: UIButton, cancelButton: UIButton){
        let contents = textView.text as NSString
        countLabel.text = "\(String(describing: contents.length))/40"
        if contents != commentLabel.text! as NSString {
            saveButton.isHidden = false
            cancelButton.isHidden = false
        } else {
            saveButton.isHidden = true
            cancelButton.isHidden = true
        }
    }
    
    //취소버튼 클릭
    func cancelMessage(commentTF: UITextView, countLabel: UILabel, commentLabel: UILabel, saveButton: UIButton, cancelButton: UIButton){
        commentTF.isHidden = true
        countLabel.isHidden = true
        saveButton.isHidden = true
        cancelButton.isHidden = true
        commentLabel.isHidden = false
        commentTF.text = commentLabel.text
        countLabel.text = "\(commentLabel.text!.count)/40"
    }
}
