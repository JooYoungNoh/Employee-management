//
//  MemoReadVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/15.
//

import UIKit
import FirebaseFirestore

class MemoReadVM{
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var titleMemo: String = ""
    
    //텍스트 필드
    func changeMemo(textView: UITextView, countLabel: UILabel){
        let contents = textView.text as NSString
        countLabel.text = "\(String(describing: contents.length))"
        let length = contents.length > 18 ? 18 : contents.length
        self.titleMemo = contents.substring(with: NSRange(location: 0, length: length))
        
        if contents.length == 0 {
            countLabel.text = "0"
        }
    }

}
