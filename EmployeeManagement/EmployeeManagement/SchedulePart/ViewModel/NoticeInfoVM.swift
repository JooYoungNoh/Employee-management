//
//  NoticeInfoVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/08.
//

import FirebaseFirestore

class NoticeInfoVM {
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var titleMemo: String = ""
    var dateSave: TimeInterval = 0
    
    //텍스트 필드
    func changeMemo(textView: UITextView, countLabel: UILabel){
        let contents = textView.text as NSString
        countLabel.text = "\(String(describing: contents.length))"
        var textCount = -1
        let length = contents.length > 18 ? 18 : contents.length
        if let rangeText = textView.text.range(of: "\n"){
            textCount = textView.text.distance(from: textView.text.startIndex, to: rangeText.lowerBound)
            self.titleMemo = contents.substring(with: NSRange(location: 0, length: textCount))
        } else {
            textCount = -1
            self.titleMemo = contents.substring(with: NSRange(location: 0, length: length))
        }
        
        if contents.length == 0 || textCount == 0{
            countLabel.text = "0"
        }
    }
    
    //저장 기능
    func saveNotice(writeTV: UITextView, countLabel: UILabel, title: String, date: TimeInterval){
        //날짜
        let dateChange = Date().timeIntervalSince1970
        self.dateSave = dateChange
        
        let query = self.db.collection("shop").document("\(self.appDelegate.schedulePartCompanyName)").collection("noticeList")
        
        query.whereField("title", isEqualTo: title).whereField("date", isEqualTo: date).getDocuments{ snapShot, error in
            for doc in snapShot!.documents{
                self.db.collection("shop").document("\(self.appDelegate.schedulePartCompanyName)").collection("noticeList").document("\(doc.documentID)").updateData([
                    "text" : "\(writeTV.text!)",
                    "title" : "\(self.titleMemo)",
                    "date" : dateChange,
                    "count" : "\(countLabel.text!)"
                ])
            }
        }
    }
}
