//
//  CalendarVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/04.
//

import FirebaseFirestore
import UIKit

class CalendarVM {
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var myScheduleList: [CalendarModel] = []
    var phoneMyScheduleList: [CalendarModel] = []
    var companyMyScheduleList: [CalendarModel] = []
    var checkSchedule: [Int] = []
    
    //MARK: 액션 메소드
    func findMySchedule(companyNameOnTable: String ,completion: @escaping([CalendarModel]) -> ()) {
        self.myScheduleList.removeAll()
        self.phoneMyScheduleList.removeAll()
        self.companyMyScheduleList.removeAll()
        self.checkSchedule.removeAll()
        
        self.db.collectionGroup("attendanceList").getDocuments{ (snapshot, error) in
            if error == nil {
                for doc in snapshot!.documents{
                    self.myScheduleList.append(CalendarModel.init(name: doc.data()["name"] as! String, phone: doc.data()["phone"] as! String, startTime: doc.data()["startTime"] as! String, endTime: doc.data()["endTime"] as! String, nextday: doc.data()["nextday"] as! Bool, allTime: doc.data()["allTime"] as! String, work: doc.data()["work"] as! String, userCheck: doc.data()["userCheck"] as! Bool, date: doc.data()["date"] as! String, company: doc.data()["company"] as! String))
                }
                while true{
                    if let index = self.myScheduleList.firstIndex(where: {$0.phone == self.appDelegate.phoneInfo!}) {
                        self.phoneMyScheduleList.append(self.myScheduleList[index])
                        self.myScheduleList.remove(at: index)
                    } else {
                        break
                    }
                }
                while true{
                    if let index = self.phoneMyScheduleList.firstIndex(where: {$0.company == companyNameOnTable}) {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm"
                        formatter.timeZone = TimeZone(identifier: "UTC")
                        //현재 시간
                        let currentDate = Date().timeIntervalSince1970
                        let changeDate = Date(timeIntervalSince1970: currentDate) + 32400
                        //스케줄 시간
                        let listDate2 = "\(self.phoneMyScheduleList[index].date) \(self.phoneMyScheduleList[index].startTime)"
                        let changeDate2 = formatter.date(from: listDate2)!
                        
                        print("날짜: \(listDate2) 현재 시간: \(changeDate) 그날 시간: \(changeDate2)")
                        print(formatter.string(from: changeDate))
                        
                        if changeDate2 >= changeDate {
                            self.companyMyScheduleList.append(self.phoneMyScheduleList[index])
                        }
                        self.phoneMyScheduleList.remove(at: index)
                    } else {
                        break
                    }
                }
                completion(self.companyMyScheduleList)
            } else {
                print(error!.localizedDescription)
            }
        
        }
    }
    
    func goNotice(uv: UIViewController, companyNameOnTable: String){
        let nv = uv.storyboard?.instantiateViewController(withIdentifier: "naviNotice")
        nv!.modalPresentationStyle = .fullScreen
        self.appDelegate.schedulePartCompanyName = companyNameOnTable
        uv.present(nv!, animated: true)
    }
    
    //MARK: 테이블 뷰 메소드
    func cellInfo(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return UITableViewCell() }

        if self.companyMyScheduleList.count == 0{
            cell.titleLabel.text = "스케줄이 없습니다"
            cell.titleLabel.textColor = .red
            cell.checkView.isHidden = true
        } else {
            if self.checkSchedule.contains(indexPath.row){
                cell.checkView.isHidden = true
            } else {
                if self.companyMyScheduleList[indexPath.row].userCheck == true {
                    cell.checkView.isHidden = true
                    self.checkSchedule.append(indexPath.row)
                } else {
                    cell.checkView.isHidden = false
                }
            }
    
            cell.titleLabel.textColor = .black
            cell.titleLabel.text = "\(self.companyMyScheduleList[indexPath.row].startTime) ~ \(self.companyMyScheduleList[indexPath.row].endTime)   (총 \(self.companyMyScheduleList[indexPath.row].allTime))"
            cell.dateLabel.text = "\(self.companyMyScheduleList[indexPath.row].date)"
        }
        
        return cell
    }
    
    func selectCell(tableView: UITableView, indexPath: IndexPath, companyNameOnTable: String){
        let cell = tableView.cellForRow(at: indexPath) as! CalendarCell
        if self.companyMyScheduleList.isEmpty == false {
            if cell.checkView.isHidden == false {
                if self.checkSchedule.contains(indexPath.row) == false{
                    cell.checkView.isHidden = true
                    self.checkSchedule.append(indexPath.row)
                    self.db.collection("shop").document("\(companyNameOnTable)").collection("scheduleList").document("\(cell.dateLabel.text!)").collection("attendanceList").document("\(self.appDelegate.phoneInfo!)").updateData([
                        "userCheck" : true
                    ])
                }
            }
        }
    }
    
    //MARK: FS캘린더 메소드
    func goTimetable(uv: UIViewController, date: Date, companyNameOnTable: String){
        guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "TimetableVC") as? TimetableVC else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        nv.dateOnTable = dateFormatter.string(from: date)
        nv.companyOnTable = companyNameOnTable
        
        uv.navigationController?.pushViewController(nv, animated: true)
    }
    
}
