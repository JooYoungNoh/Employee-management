//
//  MemoWriteVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/15.
//

import UIKit
import FirebaseFirestore

class MemoWriteVM {
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //저장 버튼
    func saveMemo(writeTV: UITextView, countLabel: UILabel) {
        //날짜
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fixDate = "\(formatter.string(from: date))"
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("memoList").addDocument(data: [
            "text" : "\(writeTV.text!)",
            "count" : "\(countLabel.text!)",
            "date" : "\(fixDate)"
        ])
    }
    
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
