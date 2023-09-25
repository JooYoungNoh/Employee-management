//
//  NoticeListVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/07.
//

import FirebaseFirestore
import UIKit

class NoticeListVM {
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var noticeList: [NoticeListModel] = []
    var realNoticeList: [NoticeListModel] = []
    
    //회사 삭제시 작성 금지 (회사 삭제 했는데 다른 사람이 작성 화면에 있을 경우 작성 금지을 위한 객체)
    var companyDelete: String = ""
    
    func findNotice(completion: @escaping([NoticeListModel]) -> ()){
        self.noticeList.removeAll()
        self.realNoticeList.removeAll()
        self.db.collection("shop").document("\(self.appDelegate.schedulePartCompanyName)").collection("noticeList").getDocuments { snapShot, error in
            if error == nil {
                for doc in snapShot!.documents{
                    self.noticeList.append(NoticeListModel.init(text: doc.data()["text"] as! String, date: doc.data()["date"] as! TimeInterval, count: doc.data()["count"] as! String, title: doc.data()["title"] as! String))
                }
                self.realNoticeList = self.noticeList.sorted(by: {$0.date > $1.date})
                completion(self.realNoticeList)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func naviTitle(uv: UIViewController){
        uv.navigationItem.title = self.appDelegate.schedulePartCompanyName
    }
    
    func noAldaButton(uv: UIViewController){
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
                if self.appDelegate.jobInfo == "2"{
                    let alert = UIAlertController(title: nil, message: "직원 이상의 직책만 사용가능합니다", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    uv.present(alert, animated: true)
                } else {
                    guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "NoticeWriteVC") as? NoticeWriteVC else { return }
                    nv.modalPresentationStyle = .fullScreen
                    uv.present(nv, animated: true)
                }
            }
        }
    }
    
    //MARK: 테이블 뷰 메소드
    func cellInfo(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListCell", for: indexPath) as? NoticeListCell else { return UITableViewCell() }
        
        if self.realNoticeList.isEmpty == true {
            cell.accessoryType = .none
            cell.titleLabel.text = "공지사항이 없습니다."
            cell.titleLabel.textColor = .red
        } else {
            cell.accessoryType = .disclosureIndicator
            
            let date = Date(timeIntervalSince1970: self.realNoticeList[indexPath.row].date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let fixDate = "\(formatter.string(from: date))"
            
            cell.titleLabel.text = self.realNoticeList[indexPath.row].title
            cell.titleLabel.textColor = .black
            cell.dateLabel.text = fixDate
        }
        return cell
    }
    
    func selectCell(uv: UIViewController, indexPath: IndexPath){
        if self.realNoticeList.isEmpty == false {
            guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "NoticeInfoVC") as? NoticeInfoVC else { return }
            nv.titleOnTable = self.realNoticeList[indexPath.row].title
            nv.dateOnTable = self.realNoticeList[indexPath.row].date
            nv.textOnTable = self.realNoticeList[indexPath.row].text
            nv.countOnTable = self.realNoticeList[indexPath.row].count
            
            uv.navigationController?.pushViewController(nv, animated: true)
        }
    }
    
    func deleteNotice(tableView: UITableView, forRowAt indexPath: IndexPath, uv: UIViewController){
        if self.realNoticeList.count != 0 {
            if self.appDelegate.jobInfo == "2" {
                let alert = UIAlertController(title: nil, message: "직원 이상의 직책만 사용가능합니다", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                uv.present(alert, animated: true)
            } else {
                self.db.collection("shop").document("\(self.appDelegate.schedulePartCompanyName)").collection("noticeList").whereField("title", isEqualTo: self.realNoticeList[indexPath.row].title).whereField("date", isEqualTo: self.realNoticeList[indexPath.row].date).getDocuments { snapShot, error in
                    for doc in snapShot!.documents {
                        self.db.collection("shop").document("\(self.appDelegate.schedulePartCompanyName)").collection("noticeList").document("\(doc.documentID)").delete()
                    }
                }
                self.realNoticeList.remove(at: indexPath.row)
                if self.realNoticeList.isEmpty == true {
                    let cell = tableView.cellForRow(at: indexPath) as! NoticeListCell
                    cell.accessoryType = .none
                    cell.titleLabel.text = "공지사항이 없습니다."
                    cell.titleLabel.textColor = .red
                    cell.dateLabel.text = ""
                } else {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}
