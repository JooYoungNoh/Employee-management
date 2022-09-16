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
    var roomTitleOnTable: String = ""           //전 화면에서 가져온 방 이름
    var activationOnTable: Bool = false         //전 화면에서 가져온 활성화 여부
    var phoneListOnTable: [String] = []         //전 화면에서 가져온 채팅방 전체 맴버
    var imgListOnTable: [imageSave] = []        //전 화면에서 가져온 이미지 리스트
    
    var reloadOnTable: Bool = false             //전 화면에서 왓다는 증거
    
    var viewModel = ChattingRoomVM()
    
    //키보드에 따른 높이조절
    var heightConstraint1: Constraint? = nil
    var heightConstraint2: Constraint? = nil
    var heightConstraint3: Constraint? = nil
    
    //텍스트 뷰 높이
    var textviewHeight: CGFloat = 0
    
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
        button.isHidden = true
        return button
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.writeTV.delegate = self
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(ChattingRoomCell.self, forCellReuseIdentifier: ChattingRoomCell.identifier)
        self.tableview.register(ChattingRoomLeftCell.self, forCellReuseIdentifier: ChattingRoomLeftCell.identifier)
        self.tableview.register(ChattingRoomSamePersonCell.self, forCellReuseIdentifier: ChattingRoomSamePersonCell.identifier)
        self.setKeyboardNotification()          //키보드 올렷다 내렷다
        self.uiCreate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.bringChattingList(dbOnTable: self.dbIDOnTable, activationOnTable: self.activationOnTable, phoneListOnTable: self.phoneListOnTable) { completion in
            if self.reloadOnTable == false {
                self.reloadOnTable = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
                    self.tableview.reloadData()
                    self.tableview.scrollToRow(at: IndexPath(row: self.viewModel.chatList.count - 1, section: 0), at: .bottom, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    self.tableview.scrollToRow(at: IndexPath(row: self.viewModel.chatList.count - 1, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewModel.deletePresentUser(dbIDOnTable: self.dbIDOnTable, phoneListOnTable: self.phoneListOnTable, activationOnTable: self.activationOnTable)
    }
    
    //MARK: 액션 메소드
    @objc func sendPicture(_ sender: UIButton){
        
    }
    
    @objc func sendMessage(_ sender: UIButton){
        self.viewModel.doSendButton(activationOnTable: self.activationOnTable, phoneListOnTable: self.phoneListOnTable, roomTitleOnTable: self.roomTitleOnTable, dbIDOnTable: self.dbIDOnTable, writeTV: self.writeTV, tableView: self.tableview)
        self.writeTV.text = ""
        self.sendButton.isHidden = true
    }

    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션
        if self.phoneListOnTable.count == 1 {
            self.navigationItem.title = self.roomTitleOnTable
        } else {
            self.navigationItem.title = "그룹채팅"
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.title = ""
        
        //테이블 뷰
        self.tableview.separatorStyle = .none
        self.tableview.backgroundColor = .systemGray6
        self.tableview.allowsSelection = false
        //탭 제스처
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
        
        //사진 추가 버튼
        self.addPictureButton.addTarget(self, action: #selector(sendPicture(_:)), for: .touchUpInside)
        self.view.addSubview(self.addPictureButton)
        addPictureButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(15)
            self.heightConstraint1 = make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).constraint
            make.width.height.equalTo(40)
        }
        
        //전송 버튼
        self.sendButton.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        self.view.addSubview(self.sendButton)
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            self.heightConstraint2 = make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).constraint
            make.width.height.equalTo(40)
        }
        
        //텍스트 필드
        self.view.addSubview(self.writeTV)
        writeTV.snp.makeConstraints { make in
            make.leading.equalTo(self.addPictureButton.snp.trailing).offset(10)
            make.trailing.equalTo(self.sendButton.snp.leading).offset(-10)
            self.heightConstraint3 = make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).constraint
            make.height.lessThanOrEqualTo(120)
        }
        
        self.view.addSubview(self.tableview)
        tableview.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.writeTV.snp.top).offset(-10)
            //self.heightConstraint = make.height.equalTo(680).constraint
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
            
            self.heightConstraint1?.update(offset: -(keyboardHeight-20))
            self.heightConstraint2?.update(offset: -(keyboardHeight-20))
            self.heightConstraint3?.update(offset: -(keyboardHeight-20))
                
            UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                self.view.layoutIfNeeded()
                self.tableview.scrollToRow(at: IndexPath.init(row: self.viewModel.chatList.count - 1, section: 0), at: .bottom, animated: false)
            }).startAnimation()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.heightConstraint1?.update(offset: 0)
        self.heightConstraint2?.update(offset: 0)
        self.heightConstraint3?.update(offset: 0)
        
        UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            self.view.layoutIfNeeded()
            self.tableview.scrollToRow(at: IndexPath.init(row: self.viewModel.chatList.count - 1, section: 0), at: .bottom, animated: false)
        }).startAnimation()
    }
}

//MARK: 테이블 뷰 메소드
extension ChattingRoomVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.viewModel.cellInfo(tableView: tableView, indexPath: indexPath, dbOnTable: self.dbIDOnTable)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: 텍스트 뷰 메소드
extension ChattingRoomVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.textViewDidChange(textView: textView, sendButton: self.sendButton)
        if self.textviewHeight != textView.bounds.height {
            self.tableview.scrollToRow(at: IndexPath.init(row: self.viewModel.chatList.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textviewHeight = textView.bounds.height
    }
   
}
