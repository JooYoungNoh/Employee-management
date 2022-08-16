//
//  MemoVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/15.
//

import UIKit
import FirebaseFirestore

class MemoVM {
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var memoList: [MemoModel] = []
    var realMemoList: [MemoModel] = []
    var searchMemoList: [MemoModel] = []
    
    func findMemo(completion: @escaping([MemoModel]) -> ()){
        self.memoList.removeAll()
        self.realMemoList.removeAll()
        self.searchMemoList.removeAll()
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("memoList").getDocuments { snapShot, error in
            if error == nil {
                for doc in snapShot!.documents{
                    self.memoList.append(MemoModel.init(text: doc.data()["text"] as! String, date: doc.data()["date"] as! TimeInterval, count: doc.data()["count"] as! String, title: doc.data()["title"] as! String))
                }
                self.realMemoList = self.memoList.sorted(by: {$0.date > $1.date})
                completion(self.realMemoList)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //MARK: 테이블 뷰 메소드
    func cellInfo(tableView: UITableView, indexPath: IndexPath, isFiltering: Bool) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.identifier, for: indexPath) as? MemoCell else { return UITableViewCell() }
        if isFiltering == false {
            if self.realMemoList.isEmpty == true {
                cell.accessoryType = .none
                cell.titleLabel.text = "메모가 없습니다"
                cell.titleLabel.textColor = .red
                cell.dateLabel.text = ""
            } else {
                let date = Date(timeIntervalSince1970: self.realMemoList[indexPath.row].date)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let fixDate = "\(formatter.string(from: date))"
                
                cell.accessoryType = .disclosureIndicator
                cell.titleLabel.text = self.realMemoList[indexPath.row].title
                cell.titleLabel.textColor = .black
                cell.dateLabel.text = fixDate
            }
        } else {
            if self.searchMemoList.isEmpty == true {
                cell.accessoryType = .none
                cell.titleLabel.text = "검색 결과가 없습니다"
                cell.titleLabel.textColor = .red
                cell.dateLabel.text = ""
            } else {
                let date2 = Date(timeIntervalSince1970: self.searchMemoList[indexPath.row].date)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let fixDate2 = "\(formatter.string(from: date2))"
                
                cell.accessoryType = .disclosureIndicator
                cell.titleLabel.text = self.searchMemoList[indexPath.row].title
                cell.titleLabel.textColor = .black
                cell.dateLabel.text = fixDate2
            }
        }
        return cell
    }
    
    func deleteMemo(tableView: UITableView, forRowAt indexPath: IndexPath, isFiltering: Bool){
        if isFiltering == false {
            let query = self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("memoList")
            
            query.whereField("title", isEqualTo: self.realMemoList[indexPath.row].title).whereField("date", isEqualTo: self.realMemoList[indexPath.row].date).getDocuments{ snapShot, error in
                for doc in snapShot!.documents{
                    print("나와라 ㅡㅡ : \(doc.documentID)")
                    query.document("\(doc.documentID)").delete()
                }
            }
            self.realMemoList.remove(at: indexPath.row)
            if self.realMemoList.isEmpty == true {
                let cell = tableView.cellForRow(at: indexPath) as! MemoCell
                cell.accessoryType = .none
                cell.titleLabel.text = "메모가 없습니다"
                cell.titleLabel.textColor = .red
                cell.dateLabel.text = ""
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else {
            let query = self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("memoList")
            
            query.whereField("title", isEqualTo: self.searchMemoList[indexPath.row].title).whereField("date", isEqualTo: self.searchMemoList[indexPath.row].date).getDocuments{ snapShot, error in
                for doc in snapShot!.documents{
                    print("나와라 ㅡㅡ : \(doc.documentID)")
                    query.document("\(doc.documentID)").delete()
                }
            }
            self.realMemoList.remove(at: self.realMemoList.firstIndex(where: { list in
                return list.title.contains(self.searchMemoList[indexPath.row].title)
            })!)
            self.searchMemoList.remove(at: indexPath.row)
            if self.searchMemoList.isEmpty == true {
                let cell = tableView.cellForRow(at: indexPath) as! MemoCell
                cell.accessoryType = .none
                cell.titleLabel.text = "검색 결과가 없습니다"
                cell.titleLabel.textColor = .red
                cell.dateLabel.text = ""
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
    }
    
    func searchBarfilter(searchController: UISearchController, tableView: UITableView){
        guard let text = searchController.searchBar.text else { return }

        self.searchMemoList = self.realMemoList.filter( { (list: MemoModel) -> Bool in
            return list.title.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
    }
    
    //테이블 뷰 섹션에 나타낼 로우 갯수
    func numberOfRowsInSection(section: Int, isFiltering: Bool) -> Int {
        if isFiltering == true {
            return self.searchMemoList.isEmpty ? 1 : self.searchMemoList.count
        } else {
            return self.realMemoList.isEmpty ? 1 : self.realMemoList.count
        }
    }
    
    func selectCell(uv: UIViewController, isFiltering: Bool, indexPath: IndexPath){
        guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "MemoReadVC") as? MemoReadVC else { return }
        
        //전달할 내용
        if isFiltering == false{
            if self.realMemoList.isEmpty == false {
                nv.titleOnTable = self.realMemoList[indexPath.row].title
                nv.dateOnTable = self.realMemoList[indexPath.row].date
                nv.textOnTable = self.realMemoList[indexPath.row].text
                nv.countOnTable = self.realMemoList[indexPath.row].count
                
                uv.navigationController?.pushViewController(nv, animated: true)
            }
        } else {
            if self.searchMemoList.isEmpty == false {
                nv.titleOnTable = self.searchMemoList[indexPath.row].title
                nv.dateOnTable = self.searchMemoList[indexPath.row].date
                nv.textOnTable = self.searchMemoList[indexPath.row].text
                nv.countOnTable = self.searchMemoList[indexPath.row].count
                
                uv.navigationController?.pushViewController(nv, animated: true)
            }
        }
    }
}
