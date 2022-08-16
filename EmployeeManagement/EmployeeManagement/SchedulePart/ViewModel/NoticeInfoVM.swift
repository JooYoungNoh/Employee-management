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
    
    //회사 삭제시 작성 금지 (회사 삭제 했는데 다른 사람이 작성 화면에 있을 경우 작성 금지을 위한 객체)
    var companyDelete: String = ""
    
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
    func saveNotice(uv: UIViewController, writeTV: UITextView, countLabel: UILabel, title: String, date: TimeInterval, textOnTable: String){
        self.companyDelete = ""
        self.db.collection("shop").whereField("company", isEqualTo: "\(self.appDelegate.schedulePartCompanyName)").getDocuments { snapShot, error in
            for doc in snapShot!.documents{
                self.companyDelete = doc.documentID
            }
            print(self.companyDelete)
            if self.companyDelete == "" {
                let alert = UIAlertController(title: "회사가 존재하지않습니다.", message: "확인해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                    uv.navigationController?.popViewController(animated: true)
                })
                uv.present(alert, animated: true)
            } else {
                if self.appDelegate.jobInfo == "2" {
                    let alert = UIAlertController(title: nil, message: "직원 이상의 직책만 사용가능합니다", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    uv.present(alert, animated: true)
                } else {
                    if textOnTable == writeTV.text {
                        let alert = UIAlertController(title: "변경사항이 없습니다", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        uv.present(alert, animated: true)
                    } else {
                        //날짜
                         let dateChange = Date().timeIntervalSince1970
                         self.dateSave = dateChange
                         
                         let alert = UIAlertController(title: "저장하시겠습니까", message: "복구가 불가능합니다", preferredStyle: .alert)
                         alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
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
                             uv.navigationController?.popViewController(animated: true)
                         })
                         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                         uv.present(alert, animated: true)
                    }
                }
            }
        }
    }
}
