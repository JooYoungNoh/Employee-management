//
//  NoticeWriteVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/08.
//

import FirebaseFirestore
import UIKit

class NoticeWriteVM {
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var titleMemo: String = ""
    
    //회사 삭제시 작성 금지 (회사 삭제 했는데 다른 사람이 작성 화면에 있을 경우 작성 금지을 위한 객체)
    var companyDelete: String = ""
    
    //저장 버튼
    func saveMemo(uv: UIViewController, writeTV: UITextView, countLabel: UILabel) {
        //날짜
        let date = Date().timeIntervalSince1970
        self.companyDelete = ""
        self.db.collection("shop").whereField("company", isEqualTo: "\(self.appDelegate.schedulePartCompanyName)").getDocuments { snapShot, error in
            for doc in snapShot!.documents{
                self.companyDelete = doc.documentID
            }
            print(self.companyDelete)
            if self.companyDelete == "" {
                let alert = UIAlertController(title: "회사가 존재하지않습니다.", message: "확인해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                    uv.dismiss(animated: true)
                })
                uv.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "저장 완료", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                    self.db.collection("shop").document("\(self.appDelegate.schedulePartCompanyName)").collection("noticeList").addDocument(data: [
                        "text" : "\(writeTV.text!)",
                        "count" : "\(countLabel.text!)",
                        "date" : date,
                        "title" : "\(self.titleMemo)"
                    ])
                    uv.dismiss(animated: true)
                })
                uv.present(alert, animated: true)
            }
        }
    }
    
    //텍스트 필드
    func changeMemo(textView: UITextView, countLabel: UILabel, saveButton: UIButton){
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
        if contents.length != 0 {
            if textCount == 0 {
                saveButton.isHidden = true
            } else {
                saveButton.isHidden = false
            }
        } else {
            saveButton.isHidden = true
            countLabel.text = "0"
        }
    }
}
