//
//  MemoWriteVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/15.
//

import UIKit
import SnapKit

class MemoWriteVC: UIViewController, UITextViewDelegate {
    
    var viewModel = MemoWriteVM()
    
    //닫기 버튼
    let closeButton: UIButton = {
        let close = UIButton()
        close.setTitle("Close", for: .normal)
        close.setTitleColor(UIColor.black, for: .normal)
        close.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return close
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Write Memo"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 25)
        return label
    }()
    
    //저장 버튼
    let saveButton: UIButton = {
        let save = UIButton()
        save.isHidden = true
        save.setTitle("Save", for: .normal)
        save.setTitleColor(UIColor.black, for: .normal)
        save.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return save
    }()
    
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

    //MARK: viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        self.writeTV.delegate = self
        uiCreate()
    }
    
    func uiCreate(){
        //닫기 버튼 UI
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        //타이틀 UI
        self.view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        //저장 버튼 UI
        saveButton.addTarget(self, action: #selector(dosave(_:)), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(75)
            make.height.equalTo(40)
        }
        
        //텍스트 뷰 UI
        self.view.addSubview(writeTV)
        
        writeTV.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(self.saveButton.snp.bottom).offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-320)
        }
        
        //글자수 UI
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
        self.viewModel.changeMemo(textView: textView, countLabel: self.countLabel, saveButton: self.saveButton)
    }
    
    //MARK: 엑션 메소드
    @objc func doclose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @objc func dosave(_ sender: UIButton) {
        
    }
    
    //MARK: tap 제스쳐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
