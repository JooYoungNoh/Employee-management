//
//  FindIDVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/10.
//

import UIKit

class FindIDVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        uiDeployment()
    }
    
    //MARK: UI 배치(No Storyboard)
    func uiDeployment(){
        //닫기 버튼
        let closeButton = UIButton()
        
        closeButton.frame = CGRect(x: 20, y: 50, width: 50, height: 40)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.init(name: "Chalkboard SE", size: 20)
        
        
        self.view.addSubview(closeButton)
        
        //아이디 찾기 레이블
        let findID = UILabel()
        
        findID.frame = CGRect(x: self.view.frame.width/2 - 100, y: 100, width: 200, height: 100)
        
        findID.text = "Find  ID"
        findID.textColor = UIColor.black
        findID.font = UIFont.init(name: "Chalkboard SE", size: 30)
        findID.textAlignment = .center
        
        self.view.addSubview(findID)
        
        //이름
        let nameImage = UIImageView(image: UIImage(systemName: "face.smiling"))
        let nameTextField = UITextField()
        
        nameImage.frame = CGRect(x: 70, y: 220, width: 30, height: 30)
        nameImage.tintColor = UIColor.systemGray2
        
        nameTextField.frame = CGRect(x: 110, y: 220, width: 200, height: 30)
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
        
        birthImage.frame = CGRect(x: 70, y: 260, width: 30, height: 30)
        birthImage.tintColor = UIColor.systemGray2
        
        birthTextField.frame = CGRect(x: 110, y: 260, width: 200, height: 30)
        birthTextField.placeholder = "Birth ex)990101"
        birthTextField.borderStyle = .roundedRect
        birthTextField.layer.borderWidth = 1
        birthTextField.layer.borderColor = UIColor.systemGray2.cgColor
        birthTextField.font = UIFont.init(name: "Chalkboard SE", size: 15)
        
        self.view.addSubview(birthImage)
        self.view.addSubview(birthTextField)
    }
}
