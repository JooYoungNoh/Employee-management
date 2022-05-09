//
//  PickerController.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/10.
//

import UIKit

class PickerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var pickerView: UIPickerView!       //피커뷰 객체
    
    //피커 뷰에 선택되어 있는 질문 가져오기 p.1069
   /* var selectedQuestion: Int{
        let row = self.pickerView.selectedRow(inComponent: 0)
        return self.departlist[row].departcd
    }*/

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
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var titleView = view as? UILabel
        if titleView == nil {
            titleView = UILabel()
            titleView?.font = UIFont.init(name: "Chalkboard SE", size: 14)
            titleView?.textAlignment = .center
        }
        titleView?.text = "질문 리스트 넣을 곳"
        
        return titleView!
    }
}
