//
//  MemoWriteVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/15.
//

import UIKit
import FirebaseFirestore

class MemoWriteVM {
    
    //텍스트 필드
    func changeMemo(textView: UITextView, countLabel: UILabel, saveButton: UIButton){
        let contents = textView.text as NSString
        countLabel.text = "\(String(describing: contents.length))"
        if contents.length != 0 {
            saveButton.isHidden = false
        } else {
            saveButton.isHidden = true
        }
    }
}
