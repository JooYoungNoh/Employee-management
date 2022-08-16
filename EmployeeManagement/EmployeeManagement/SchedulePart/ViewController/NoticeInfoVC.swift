//
//  NoticeInfoVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/08.
//

import UIKit

class NoticeInfoVC: UIViewController, UITextViewDelegate {

    var titleOnTable: String = ""               //전 회면 셀에 있는 제목
    var dateOnTable: TimeInterval = 0           //전 회면 셀에 있는 작성시간
    var textOnTable: String = ""                //전 회면 셀에 있는 내용
    var countOnTable: String = ""               //전 화면 셀에 있는 글자수
    
    var viewModel = NoticeInfoVM()
    
    let writeTV: UITextView = {
       let write = UITextView()
        write.textColor = UIColor.black
        write.font = UIFont(name: "CookieRun", size: 18)
        write.textAlignment = .left
        write.backgroundColor = .systemGray6
        return write
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0"
        label.font = UIFont(name: "CookieRun", size: 15)
        label.textAlignment = .right
        return label
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.writeTV.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiCreate()
    }
    
    func uiCreate(){
        //내비게이션 UI
        self.navigationItem.title = "공지사항"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        let saveButton = UIBarButtonItem.init(title: "저장", style: .plain, target: self, action: #selector(dosave(_:)))
        
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.backBarButtonItem?.tintColor = .black
        saveButton.tintColor = UIColor.black
        
        //텍스트 뷰 UI
        self.writeTV.text = self.textOnTable
        self.view.addSubview(writeTV)
        
        writeTV.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        
        //글자수 UI
        self.countLabel.text = self.countOnTable
        self.view.addSubview(countLabel)
        
        countLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.writeTV.snp.trailing)
            make.top.equalTo(self.writeTV.snp.bottom)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    //MARK: 텍스트 뷰 메소드
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.changeMemo(textView: textView, countLabel: self.countLabel)
    }

    //MARK: 액션 메소드
    @objc func dosave(_ sender: UIBarButtonItem){
        self.viewModel.saveNotice(uv: self, writeTV: self.writeTV, countLabel: self.countLabel, title: self.titleOnTable, date: self.dateOnTable, textOnTable: self.textOnTable)
    }
    
    //MARK: tap 제스쳐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
