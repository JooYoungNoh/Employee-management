//
//  TimetableCreateVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/10.
//

import UIKit
import Foundation
import SnapKit

class TimetableCreateVC: UIViewController {

    var dateOnTable: String = ""                   //전 화면에서 받아오는 날짜
    var companyOnTable: String = ""                //전 화면에서 받아오는 회사 이름
    
    var questionList = [(0,"나의 보물 1호는?"), (1,"내가 사는 곳은?"), (2,"내가 다녔던 고등학교는?")]
    
    var viewModel = TimetableCreateVM()
    
    //닫기 버튼
    let closeButton: UIButton = {
        let close = UIButton()
        close.setTitle("Close", for: .normal)
        close.setTitleColor(UIColor.black, for: .normal)
        close.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return close
    }()
    
    //타이틀 레이블
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "시간표 작성"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 20)
        return label
    }()
    
    //저장 버튼
    let saveButton: UIButton = {
        let save = UIButton()
        save.setTitle("Save", for: .normal)
        save.setTitleColor(UIColor.black, for: .normal)
        save.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return save
    }()
    
    //이름 레이블
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름:"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .systemGray6
        picker.layer.cornerRadius = 10
        picker.layer.masksToBounds = true
        picker.layer.borderWidth = 0
        return picker
    }()
    //날짜 레이블
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜:"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let dateResult: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    //시작 시간
    let startLabel: UILabel = {
        let label = UILabel()
        label.text = "시작 시간:"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let startTF: UITextField = {
        let text = UITextField()
        text.backgroundColor = .systemGray6
        text.placeholder = "00:00"
        text.textColor = .black
        text.textAlignment = .center
        text.font = UIFont(name: "CookieRun", size: 18)
        text.layer.cornerRadius = 10
        text.layer.masksToBounds = true
        text.layer.borderWidth = 0
        return text
    }()
    
    //끝 시간
    let endLabel: UILabel = {
        let label = UILabel()
        label.text = "끝 시간:"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let endTF: UITextField = {
        let text = UITextField()
        text.backgroundColor = .systemGray6
        text.placeholder = "00:00"
        text.textColor = .black
        text.textAlignment = .center
        text.font = UIFont(name: "CookieRun", size: 18)
        text.layer.cornerRadius = 10
        text.layer.masksToBounds = true
        text.layer.borderWidth = 0
        return text
    }()
    
    let nextButton: UIButton = {
        let button  = UIButton()
        button.setTitle(" 다음날", for: .normal)
        button.setTitleColor(UIColor.systemGray5, for: .normal)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .systemGray5
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 18)
        return button
    }()
    
    //총 시간
    let allLabel: UILabel = {
        let label = UILabel()
        label.text = "총 시간"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let allResult: UILabel = {
        let label = UILabel()
        label.text = "0.0 시간"
        label.textAlignment = .center
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    //할 일
    let workLabel: UILabel = {
        let label = UILabel()
        label.text = "할 일:"
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let workTV: UITextView = {
       let write = UITextView()
        write.textColor = .black
        write.font = UIFont(name: "CookieRun", size: 18)
        write.textAlignment = .left
        write.backgroundColor = .systemGray6
        write.layer.cornerRadius = 10
        write.layer.masksToBounds = true
        write.layer.borderWidth = 0
        return write
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiCreate()
        self.startTF.delegate = self
        self.endTF.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        /*
        let aaa = DateFormatter()
        aaa.dateFormat = "yyyy-MM-dd"
        let ssa = aaa.date(from: self.dateOnTable)!
        print(aaa.string(from: ssa-86400))*/
    }
    
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @objc func dosave(_ sender: UIButton){
        
    }
    
    @objc func checkNextDay(_ sender: UIButton){
        self.viewModel.checkNextDay(nextButton: self.nextButton, allResult: self.allResult, endTF: self.endTF)
    }
    
    //MARK: 화면 메소드
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
        
        //이름 레이블
        self.view.addSubview(self.nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(50)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.pickerView)
        self.pickerView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.nameLabel.snp.trailing).offset(20)
            make.width.equalTo(230)
            make.height.equalTo(80)
        
        }
        
        //날짜 레이블 UI
        self.view.addSubview(self.dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(50)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.dateResult.text = self.dateOnTable
        self.view.addSubview(self.dateResult)
        dateResult.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        //시작 시간 레이블 UI
        self.view.addSubview(self.startLabel)
        startLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.dateLabel.snp.leading)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.startTF)
        startTF.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        //끝 시간 레이블 UI
        self.view.addSubview(self.endLabel)
        endLabel.snp.makeConstraints { make in
            make.top.equalTo(self.startLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.dateLabel.snp.leading)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.endTF)
        endTF.snp.makeConstraints { make in
            make.top.equalTo(self.startLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        self.nextButton.addTarget(self, action: #selector(checkNextDay(_:)), for: .touchUpInside)
        self.view.addSubview(self.nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(self.startLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.endTF.snp.trailing).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        //총 시간 레이블 UI
        self.view.addSubview(self.allLabel)
        allLabel.snp.makeConstraints { make in
            make.top.equalTo(self.endLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.dateLabel.snp.leading)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.allResult)
        allResult.snp.makeConstraints { make in
            make.top.equalTo(self.endLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        //할 일 레이블 UI
        self.view.addSubview(self.workLabel)
        workLabel.snp.makeConstraints { make in
            make.top.equalTo(self.allLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.dateLabel.snp.leading)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.workTV)
        workTV.snp.makeConstraints { make in
            make.top.equalTo(self.allLabel.snp.bottom).offset(40)
            make.leading.equalTo(self.workLabel.snp.trailing).offset(20)
            make.bottom.equalTo(self.view.snp.bottom).offset(-100)
            make.width.equalTo(230)
        }
    }
    
    //MARK: tap 제스쳐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: 텍스트 필드 메소드
extension TimetableCreateVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.textEndEditing(uv: self, textField: textField, allResult: self.allResult, startTF: self.startTF, endTF: self.endTF, nextButton: self.nextButton)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.viewModel.textWritingCase(string: string)
    }
}

//MARK: 피커뷰 메소드
extension TimetableCreateVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.questionList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var titleView = view as? UILabel
        if titleView == nil {
            titleView = UILabel()
            titleView?.font = UIFont.init(name: "CookieRun", size: 15)
            titleView?.textAlignment = .center
        }
        titleView?.text = "\(self.questionList[row].1)"
        
        return titleView!
    }
}
