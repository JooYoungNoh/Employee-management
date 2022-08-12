//
//  TimetableCreateVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/10.
//

import Foundation
import UIKit
import FirebaseFirestore

class TimetableCreateVM {
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var pickName: String = ""
    var pickPhone: String = ""
    var selectNameList: [String] = []
    var checkList: [String] = []
    
    //어제랑 겹치는 시간 있는지 찾기
    var nextdayCheck: Bool = false
    var endTimeCheck: String = ""
    
    //문자 조건
    let charSet: CharacterSet = {
        var cs = CharacterSet()
        cs.insert(charactersIn: "0123456789")
        cs.insert(charactersIn: ":")
        return cs.inverted
    }()
    
    
    //MARK: 액션 메소드
    func findName(companyOnTable: String, completion: @escaping([String]) -> ()) {
        self.selectNameList.removeAll()
        self.db.collection("shop").document("\(companyOnTable)").collection("employeeControl").getDocuments { (snapshot, error) in
            if error == nil {
                for doc in snapshot!.documents{
                    self.selectNameList.append("\(doc.data()["name"] as! String) \(doc.data()["phone"] as! String)")
                }
                let cutSelect = self.selectNameList[0].split(separator: " ")
                
                self.pickName = "\(cutSelect[0])"
                self.pickPhone = "\(cutSelect[1])"
                completion(self.selectNameList)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func checkNextDay(nextButton: UIButton, allResult: UILabel, endTF: UITextField){
        if nextButton.tintColor == .systemGray5 {
            nextButton.tintColor = .black
            nextButton.setTitleColor(UIColor.black, for: .normal)
            allResult.text = "0.0 시간"
            endTF.text = ""
        } else {
            nextButton.tintColor = .systemGray5
            nextButton.setTitleColor(UIColor.systemGray5, for: .normal)
            allResult.text = "0.0 시간"
            endTF.text = ""
        }
    }
    
    func doSave(uv: UIViewController, companyOnTable: String, dateOnTable: String, workTV: UITextView, startTF: UITextField, endTF: UITextField, allResult: UILabel, nextButton: UIButton){
        self.nextdayCheck = false
        self.endTimeCheck = ""
        
        if allResult.text == "0.0 시간" {
            let alert = UIAlertController(title: "올바른 시간표가 아닙니다", message: "다시 작성해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            uv.present(alert, animated: true)
        } else {
            self.db.collection("shop").document("\(companyOnTable)").collection("scheduleList").document("\(dateOnTable)").collection("attendanceList").whereField("phone", isEqualTo: self.pickPhone).getDocuments { (snapshot, error) in
                if error == nil {
                    for doc in snapshot!.documents{
                        self.checkList.append(doc.documentID)
                    }
                    if self.checkList.isEmpty == false {
                        let alert = UIAlertController(title: "이미 스케줄에 있습니다", message: "확인해주세요", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        uv.present(alert, animated: true)
                    } else {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let today = dateFormatter.date(from: "\(dateOnTable)")!
                        let yesterday = dateFormatter.string(from: today - 86400)
                        //어제 날짜랑 시간 겹치는지 찾기
                        self.db.collection("shop").document("\(companyOnTable)").collection("scheduleList").document("\(yesterday)").collection("attendanceList").whereField("phone", isEqualTo: "\(self.pickPhone)").getDocuments{ (snapshot3, error) in
                            for doc3 in snapshot3!.documents{
                                self.nextdayCheck = doc3.data()["nextday"] as! Bool
                                self.endTimeCheck = doc3.data()["endTime"] as! String
                            }
                            let dateFormatter2 = DateFormatter()
                            dateFormatter2.dateFormat = "HH:mm"
                            let yesterdayEnd = dateFormatter2.date(from: self.endTimeCheck)!
                            let todayStart = dateFormatter2.date(from: startTF.text!)!
                            
                            if self.nextdayCheck == true && Double(yesterdayEnd.timeIntervalSince(todayStart)) > 0{
                                let alert = UIAlertController(title: "어제 스케줄과 겹칩니다", message: "확인해주세요", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default))
                                uv.present(alert, animated: true)
                            } else {
                                //내 스케줄 찾기를 위해 문서 아이디 활성화
                                self.db.collection("shop").document("\(companyOnTable)").collection("scheduleList").document("\(dateOnTable)").setData([
                                    "scheduleState" : true
                                ])
                                
                                self.db.collection("shop").document("\(companyOnTable)").collection("scheduleList").document("\(dateOnTable)").collection("attendanceList").document("\(self.pickPhone)").setData([
                                    "name" : self.pickName,             //이름
                                    "phone" : self.pickPhone,           //전화번호
                                    "startTime" : "\(startTF.text!)",    //시작 시간
                                    "endTime" : "\(endTF.text!)",        //끝 시간
                                    "nextday" : nextButton.tintColor == .black ? true : false ,                         //다음 날 체크
                                    "allTime" : "\(allResult.text!)",    //총 시간
                                    "work" : "\(workTV.text ?? "")",    //할 일
                                    "userCheck" : false,               //유저가 체크했는지
                                    "date" : dateOnTable                //날짜
                                ])
                                uv.dismiss(animated: true)
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    //MARK: 텍스트 필드 메소드
    func textEndEditing(uv: UIViewController,textField: UITextField, allResult: UILabel, startTF: UITextField, endTF: UITextField, nextButton: UIButton){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        var start: Date!
        var end: Date!
        var tfCheck: [Character] = []
        var checkBool: Bool = true
        
        if let tfText = textField.text {
            for i in tfText{
                tfCheck.append(i)
            }
            if tfCheck.count != 5 && tfCheck.count > 0{
                let alert = UIAlertController(title: "잘못 입력되었습니다", message: "다시 입력해주세여", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                    textField.text = ""
                    allResult.text = "0.0 시간"
                })
                uv.present(alert, animated: true)
            } else {
                if tfCheck.count > 0 {
                    for i in 0...4{
                        switch i {
                        case 0,1,3,4:
                            if tfCheck[i].isNumber == false {
                                checkBool = false
                            }
                        default:
                            if tfCheck[i] != ":" {
                                checkBool = false
                            }
                        }
                        if checkBool == false {
                            let alert = UIAlertController(title: "잘못 입력되었습니다", message: "다시 입력해주세여", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                                textField.text = ""
                                allResult.text = "0.0 시간"
                            })
                            uv.present(alert, animated: true)
                            break
                        }
                    }
                }
            }
        }
        
        if checkBool == true {
            if textField == startTF {
                if endTF.text?.isEmpty == false && textField.text?.isEmpty == false && endTF.text?.count == 5 && textField.text?.count == 5{
                    var maxTimeStart: [Character] = []
                    var maxTimeEnd: [Character] = []
                    for i in textField.text! {
                        maxTimeStart.append(i)
                    }
                    for i in endTF.text! {
                        maxTimeEnd.append(i)
                    }
                    
                    if Int(String(maxTimeStart[0]) + String(maxTimeStart[1]))! < 24 && Int(String(maxTimeStart[3]) + String(maxTimeStart[4]))! < 60 && Int(String(maxTimeEnd[0]) + String(maxTimeEnd[1]))! < 24 && Int(String(maxTimeEnd[3]) + String(maxTimeEnd[4]))! < 60 {
                        
                        start = dateFormatter.date(from: startTF.text!)!
                        end = dateFormatter.date(from: endTF.text!)!
                        if nextButton.tintColor == .black {
                            let zeroTime = dateFormatter.date(from: "00:00")!
                            let firstTime = (86400.0 - Double(start.timeIntervalSince(zeroTime)))
                            let secoundTime = Double(end.timeIntervalSince(zeroTime))
                            let sumTime = (firstTime + secoundTime) / 3600
                            let changeSumTime = round(sumTime*10)/10
                            allResult.text = "\(changeSumTime) 시간"
                        } else {
                            let usetime = Double(end.timeIntervalSince(start))/3600
                            let changeTime = round(usetime*10)/10
                            if changeTime < 0 {
                                let alert = UIAlertController(title: "잘못 입력되었습니다", message: "다시 입력해주세여", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                                    textField.text = ""
                                    endTF.text = ""
                                    allResult.text = "0.0 시간"
                                })
                                uv.present(alert, animated: true)
                            } else {
                                allResult.text = "\(changeTime) 시간"
                            }
                        }
                    } else {
                        let alert = UIAlertController(title: "잘못 입력되었습니다", message: "다시 입력해주세여", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                            textField.text = ""
                            endTF.text = ""
                            allResult.text = "0.0 시간"
                        })
                        uv.present(alert, animated: true)
                    }
                }
            } else {
                if startTF.text?.isEmpty == false && textField.text?.isEmpty == false && startTF.text?.count == 5 && textField.text?.count == 5 {
                    var maxTimeStart: [Character] = []
                    var maxTimeEnd: [Character] = []
                    for i in startTF.text! {
                        maxTimeStart.append(i)
                    }
                    for i in textField.text! {
                        maxTimeEnd.append(i)
                    }
                    if Int(String(maxTimeStart[0]) + String(maxTimeStart[1]))! < 24 && Int(String(maxTimeStart[3]) + String(maxTimeStart[4]))! < 60 && Int(String(maxTimeEnd[0]) + String(maxTimeEnd[1]))! < 24 && Int(String(maxTimeEnd[3]) + String(maxTimeEnd[4]))! < 60 {
                        start = dateFormatter.date(from: startTF.text!)!
                        end = dateFormatter.date(from: endTF.text!)!
                        if nextButton.tintColor == .black {
                            let zeroTime = dateFormatter.date(from: "00:00")!
                            let firstTime = (86400.0 - Double(start.timeIntervalSince(zeroTime)))
                            let secoundTime = Double(end.timeIntervalSince(zeroTime))
                            let sumTime = (firstTime + secoundTime) / 3600
                            let changeSumTime = round(sumTime*10)/10
                            allResult.text = "\(changeSumTime) 시간"
                        } else {
                            let usetime = Double(end.timeIntervalSince(start))/3600
                            let changeTime = round(usetime*10)/10
                            if changeTime < 0 {
                                let alert = UIAlertController(title: "잘못 입력되었습니다", message: "다시 입력해주세여", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                                    textField.text = ""
                                    startTF.text = ""
                                    allResult.text = "0.0 시간"
                                })
                                uv.present(alert, animated: true)
                            } else {
                                allResult.text = "\(changeTime) 시간"
                            }
                        }
                    } else {
                        let alert = UIAlertController(title: "잘못 입력되었습니다", message: "다시 입력해주세여", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                            textField.text = ""
                            startTF.text = ""
                            allResult.text = "0.0 시간"
                        })
                        uv.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    //텍스트필드에 쓸 수 있는 문자
    func textWritingCase(string: String) -> Bool{
        if string.count > 0{
            guard string.rangeOfCharacter(from: self.charSet) == nil else{
                return false
            }
        }
        return true
    }
    
    //MARK: 피커뷰 메소드
    func viewForRow(view: UIView?, row: Int) -> UIView{
        var titleView = view as? UILabel
        if titleView == nil {
            titleView = UILabel()
            titleView?.font = UIFont.init(name: "CookieRun", size: 15)
            titleView?.textAlignment = .center
        }
        titleView?.text = self.selectNameList[row]
        return titleView!
    }
    
    func didSelectRow(row: Int){
        let cutSelect = self.selectNameList[row].split(separator: " ")
        
        self.pickName = "\(cutSelect[0])"
        self.pickPhone = "\(cutSelect[1])"
        
    }
}
