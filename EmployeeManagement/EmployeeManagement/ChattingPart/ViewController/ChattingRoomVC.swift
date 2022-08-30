//
//  ChattingRoomVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/26.
//

import UIKit
import SnapKit

class ChattingRoomVC: UIViewController {

    var dbIDOnTable: String = ""                //전 화면에서 가져온 문서 ID
    var activationOnTable: Bool = false         //전 화면에서 가져온 활성화 여부
    var presentUserOnTable: [String] = []       //전 화면에서 가져온 현재 방에 있는 사람
    var imgListOnTable: [imageSave] = []        //전 화면에서 가져온 이미지 리스트
    
    var viewModel = ChattingRoomVM()
    
    //테이블 뷰 높이
    var changeHeight: Int = 680
    var heightConstraint: Constraint? = nil
    
    //테이블 뷰
    let tableview = UITableView()
    
    //사진 추가 버튼
    let addPictureButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.baseForegroundColor = .black
        config.image = UIImage(systemName: "photo")
        let button = UIButton(configuration: config)
        return button
    }()
    
    //텍스트 필드
    let writeTV: UITextView = {
        let text = UITextView()
        text.backgroundColor = .systemGray6
        text.textColor = .black
        text.textAlignment = .left
        text.font = UIFont(name: "CookieRun", size: 15)
        text.layer.cornerRadius = 10
        text.layer.masksToBounds = true
        text.layer.borderWidth = 0
        text.isScrollEnabled = false
        return text
    }()
    
    //전송 버튼
    let sendButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.baseForegroundColor = .black
        config.image = UIImage(systemName: "arrow.up.circle.fill")
        let button = UIButton(configuration: config)
        return button
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.writeTV.delegate = self
        self.setKeyboardNotification()          //키보드 올렷다 내렷다
        self.uiCreate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewModel.deletePresentUser(presentUserOnTable: self.presentUserOnTable, dbIDOnTable: self.dbIDOnTable)
    }
    
    //MARK: 액션 메소드
    @objc func sendPicture(_ sender: UIButton){
        
    }
    
    @objc func sendMessage(_ sender: UIButton){
        
    }

    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션
        self.navigationItem.title = "그룹채팅"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.title = "3"
        
        //테이블 뷰
        self.tableview.backgroundColor = .systemGray6
        //탭 제스처
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(self.tableview)
        tableview.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            self.heightConstraint = make.height.equalTo(680).constraint
        }
        
        //텍스트 필드
        self.view.addSubview(self.writeTV)
        writeTV.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(55)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-55)
            make.top.equalTo(self.tableview.snp.bottom).offset(6)
            make.height.lessThanOrEqualTo(120)
        }
        
        //사진 추가 버튼
        self.addPictureButton.addTarget(self, action: #selector(sendPicture(_:)), for: .touchUpInside)
        self.view.addSubview(self.addPictureButton)
        addPictureButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(15)
            make.bottom.equalTo(self.writeTV.snp.bottom)
            make.width.height.equalTo(30)
        }
        
        //전송 버튼
        self.sendButton.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        self.view.addSubview(self.sendButton)
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            make.bottom.equalTo(self.writeTV.snp.bottom)
            make.width.height.equalTo(30)
        }
    }
    
    //MARK: tap 제스쳐
    @objc func hideKeyboard(_ sender: Any){
        self.view.endEditing(true)
    }
}

//MARK: textView 클릭 시 뷰가 올라가도록
extension ChattingRoomVC {
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
            
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
            
            if self.changeHeight == 680 {
                self.changeHeight -= (Int(keyboardHeight - 30))
                self.heightConstraint?.update(offset: self.changeHeight)
                
                UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                    self.view.layoutIfNeeded()
                }).startAnimation()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.changeHeight != 680 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                self.changeHeight += (Int(keyboardHeight - 30))
                self.heightConstraint?.update(offset: self.changeHeight)
                
                UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                    self.view.layoutIfNeeded()
                }).startAnimation()
            }
        }
    }
}

/*//MARK: 텍스트 뷰 메소드
extension ChattingRoomVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.frame.height <= 30 {
            self.textViewHeight = 0
        } else if textView.frame.height <= 60 {
            self.textViewHeight = 30
        } else if textView.frame.height <= 90 {
            self.textViewHeight = 60
        } else {
            self.textViewHeight = 90
        }
    }
   
}*/
