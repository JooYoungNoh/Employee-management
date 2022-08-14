//
//  TimetableVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/09.
//

import Foundation
import UIKit
import FirebaseFirestore
import SnapKit

class TimetableVM {
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var scheduleList: [TimetableModel] = []
    
    
    //MARK: 액션 메소드
    func findName(companyOnTable: String, dateOnTable: String, timeLabel: UILabel, completion: @escaping([TimetableModel]) -> ()) {
        self.scheduleList.removeAll()
        self.db.collection("shop").document("\(companyOnTable)").collection("scheduleList").document("\(dateOnTable)").collection("attendanceList").getDocuments { (snapshot, error) in
            if error == nil {
                for doc in snapshot!.documents{
                    self.scheduleList.append(TimetableModel.init(name: doc.data()["name"] as! String, phone: doc.data()["phone"] as! String, startTime: doc.data()["startTime"] as! String, endTime: doc.data()["endTime"] as! String, nextday: doc.data()["nextday"] as! Bool, allTime: doc.data()["allTime"] as! String, work: doc.data()["work"] as! String, userCheck: doc.data()["userCheck"] as! Bool, date: doc.data()["date"] as! String, company: doc.data()["company"] as! String))
                }
                if self.scheduleList.count == 0 {
                    timeLabel.text = "시간표 없음"
                    timeLabel.textColor = .red
                }
                completion(self.scheduleList)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func addTimetable(uv: UIViewController, companyOnTable: String, dateOnTable: String){
        if self.appDelegate.jobInfo == "2" {
            let alert = UIAlertController(title: nil, message: "직원 이상의 직책만 사용가능합니다", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            uv.present(alert, animated: true)
        } else {
            guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "TimetableCreateVC") as? TimetableCreateVC else { return }
            nv.modalPresentationStyle = .fullScreen
            nv.companyOnTable = companyOnTable
            nv.dateOnTable = dateOnTable
            
            uv.present(nv, animated: true)
        }
    }
    
    //MARK: 컬랙션 뷰 메소드
    func cellInfo(collectionView: UICollectionView, indexPath: IndexPath, timeLabel: UILabel) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimetableCell.identifier, for: indexPath) as? TimetableCell else { return UICollectionViewCell() }
        var topsize: Double = 0
        var resultHeight: Double = 0
        var resultTop: Double = 0
        let mySize: Double = 30
        var resultEndHight: Double = 0
        
        let changeAllTime = Double(self.scheduleList[indexPath.row].allTime.split(separator: " ")[0])!
            
        //cell에 이름
        cell.cellNameLabel.text = self.scheduleList[indexPath.row].name
            
        
        //cell에 막대 그래프
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let startTimeCell = dateFormatter.date(from: self.scheduleList[indexPath.row].startTime)!
        let endTimeCell = dateFormatter.date(from: self.scheduleList[indexPath.row].endTime)!
        let secondTime = Double(self.scheduleList[indexPath.row].startTime.split(separator: ":")[1])!
        
        
        if startTimeCell < dateFormatter.date(from: "09:00")! {
            topsize = 0
        } else if startTimeCell < dateFormatter.date(from: "10:00")! {
            topsize = 26
        } else if startTimeCell < dateFormatter.date(from: "11:00")! {
            topsize = 26 + (mySize * 1) + 4
        } else if startTimeCell < dateFormatter.date(from: "12:00")! {
            topsize = 26 + (mySize * 2) + 8
        } else if startTimeCell < dateFormatter.date(from: "13:00")! {
            topsize = 26 + (mySize * 3) + 12
        } else if startTimeCell < dateFormatter.date(from: "14:00")! {
            topsize = 26 + (mySize * 4) + 16
        } else if startTimeCell < dateFormatter.date(from: "15:00")! {
            topsize = 26 + (mySize * 5) + 20
        } else if startTimeCell < dateFormatter.date(from: "16:00")! {
            topsize = 26 + (mySize * 6) + 24
        } else if startTimeCell < dateFormatter.date(from: "17:00")! {
            topsize = 26 + (mySize * 7) + 28
        } else if startTimeCell < dateFormatter.date(from: "18:00")! {
            topsize = 26 + (mySize * 8) + 32
        } else if startTimeCell < dateFormatter.date(from: "19:00")! {
            topsize = 26 + (mySize * 9) + 36
        } else if startTimeCell < dateFormatter.date(from: "20:00")! {
            topsize = 26 + (mySize * 10) + 40
        } else if startTimeCell < dateFormatter.date(from: "21:00")! {
            topsize = 26 + (mySize * 11) + 44
        } else if startTimeCell < dateFormatter.date(from: "22:00")! {
            topsize = 26 + (mySize * 12) + 48
        } else if startTimeCell < dateFormatter.date(from: "23:00")! {
            topsize = 26 + (mySize * 13) + 52
        } else {
            topsize = 26 + (mySize * 14) + 56
        }
        
        resultTop = topsize + (secondTime * 0.5)
        
        if changeAllTime < 0 {
            resultHeight = mySize * changeAllTime
        } else if changeAllTime < 1 {
            resultHeight = mySize * changeAllTime + 4
        } else if changeAllTime < 2 {
            resultHeight = mySize * changeAllTime + 8
        } else if changeAllTime < 3 {
            resultHeight = mySize * changeAllTime + 12
        } else if changeAllTime < 4 {
            resultHeight = mySize * changeAllTime + 16
        } else if changeAllTime < 5 {
            resultHeight = mySize * changeAllTime + 20
        } else if changeAllTime < 6 {
            resultHeight = mySize * changeAllTime + 24
        } else if changeAllTime < 7 {
            resultHeight = mySize * changeAllTime + 28
        } else if changeAllTime < 8 {
            resultHeight = mySize * changeAllTime + 32
        } else if changeAllTime < 9 {
            resultHeight = mySize * changeAllTime + 36
        } else if changeAllTime < 10 {
            resultHeight = mySize * changeAllTime + 40
        } else if changeAllTime < 11 {
            resultHeight = mySize * changeAllTime + 44
        } else if changeAllTime < 12 {
            resultHeight = mySize * changeAllTime + 48
        } else if changeAllTime < 14 {
            resultHeight = mySize * changeAllTime + 52
        } else if changeAllTime < 15 {
            resultHeight = mySize * changeAllTime + 56
        } else if changeAllTime < 16 {
            resultHeight = mySize * changeAllTime + 60
        } else if changeAllTime < 17{
            resultHeight = mySize * changeAllTime + 64
        } else  {
            resultHeight = mySize * changeAllTime + 60
        }
        
        cell.timeCheckView.snp.removeConstraints()          //셀 기존 구조 초기화
        
        if topsize == 0 {           //새벽에 일하고 9시 전에 끝날 때
            if endTimeCell < dateFormatter.date(from: "09:00")!{
                cell.timeCheckView.snp.makeConstraints { make in
                    make.centerX.equalTo(cell.cellNameLabel.snp.centerX)
                    make.top.equalTo(cell.cellNameLabel.snp.bottom)
                    make.width.equalTo(35)
                    make.height.equalTo(26)
                }
            } else {                //새벽에 일하고 9시 이후에 끝날 때
                let resultEndTime = Double(endTimeCell.timeIntervalSince(dateFormatter.date(from: "09:00")!)) / 3600
                
                let changeResultEndTime = round(resultEndTime*10)/10
                
                if changeResultEndTime < 1 {
                    resultEndHight = mySize * changeResultEndTime
                } else if changeResultEndTime < 2 {
                    resultEndHight = mySize * changeResultEndTime + 4
                } else if changeResultEndTime < 3 {
                    resultEndHight = mySize * changeResultEndTime + 8
                } else if changeResultEndTime < 4 {
                    resultEndHight = mySize * changeResultEndTime + 12
                } else if changeResultEndTime < 5 {
                    resultEndHight = mySize * changeResultEndTime + 16
                } else if changeResultEndTime < 6 {
                    resultEndHight = mySize * changeResultEndTime + 20
                } else if changeResultEndTime < 7 {
                    resultEndHight = mySize * changeResultEndTime + 24
                } else if changeResultEndTime < 8 {
                    resultEndHight = mySize * changeResultEndTime + 28
                } else if changeResultEndTime < 9 {
                    resultEndHight = mySize * changeResultEndTime + 32
                } else if changeResultEndTime < 10 {
                    resultEndHight = mySize * changeResultEndTime + 36
                } else if changeResultEndTime < 11 {
                    resultEndHight = mySize * changeResultEndTime + 40
                } else if changeResultEndTime < 12 {
                    resultEndHight = mySize * changeResultEndTime + 44
                } else if changeResultEndTime < 13 {
                    resultEndHight = mySize * changeResultEndTime + 48
                } else if changeResultEndTime < 15 {
                    resultEndHight = mySize * changeResultEndTime + 52
                } else if changeResultEndTime < 16 {
                    resultEndHight = mySize * changeResultEndTime + 56
                } else {
                    resultEndHight = mySize * changeResultEndTime + 60
                }
                
                cell.timeCheckView.snp.makeConstraints { make in
                    make.centerX.equalTo(cell.cellNameLabel.snp.centerX)
                    make.top.equalTo(cell.cellNameLabel.snp.bottom)
                    make.width.equalTo(35)
                    make.height.equalTo(resultEndHight+26)
                }
            }
        } else if resultTop + resultHeight < 570 {     //9시 이후 일하는데 다음날 까지 일
            cell.timeCheckView.snp.makeConstraints { make in
                make.centerX.equalTo(cell.cellNameLabel.snp.centerX)
                make.top.equalTo(cell.cellNameLabel.snp.bottom).offset(resultTop)
                make.width.equalTo(35)
                make.height.equalTo(resultHeight)
            }
        } else {                                    //9시 이후 일하는데 오늘만 일할 때
            cell.timeCheckView.snp.makeConstraints { make in
                make.centerX.equalTo(cell.cellNameLabel.snp.centerX)
                make.top.equalTo(cell.cellNameLabel.snp.bottom).offset(resultTop)
                make.bottom.equalTo(cell.snp.bottom)
                make.width.equalTo(35)
            }
        }        
        return cell
    }
}

