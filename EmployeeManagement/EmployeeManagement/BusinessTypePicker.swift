//
//  BusinessTypePicker.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/18.
//

import UIKit

class BusinessTypePicker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var pickerView: UIPickerView!       //피커뷰 객체
    
    var questionList = [(0,"서비스업"), (1,"금융/은행업"), (2,"IT/정보통신업"), (3,"판매/유통업"), (4,"제조/생산/화학업"), (5,"교육업"), (6,"건설업"), (7,"의료/제약업"), (8,"건설업"), (9,"의료/제약업"), (10,"미디어/광고업"), (11,"문화/예술/디자인업")]
    
    //피커 뷰에 선택되어 있는 질문 가져오기
    var selectedQuestion: String{
        let row = self.pickerView.selectedRow(inComponent: 0)
        return self.questionList[row].1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //비밀번호 질문 피커뷰
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.view.addSubview(self.pickerView)
        
        //외부에서 뷰 컨트롤러를 참조할 때를 위한 사이즈 지정
        let pWidth = self.pickerView.frame.width
        let pHeight = self.pickerView.frame.height
        self.preferredContentSize = CGSize(width: pWidth, height: pHeight)
    }
    
    //MARK: 피커뷰 메소드
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
            titleView?.font = UIFont.init(name: "Chalkboard SE", size: 14)
            titleView?.textAlignment = .center
        }
        titleView?.text = "\(self.questionList[row].1)"
        
        return titleView!
    }
}

