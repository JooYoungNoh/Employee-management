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
    
    func deleteMemo(tableView: UITableView, forRowAt indexPath: IndexPath, realMemoList: [MemoModel]){
        let query = self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("memoList")
        
        query.whereField("title", isEqualTo: realMemoList[indexPath.row].title).whereField("date", isEqualTo: realMemoList[indexPath.row].date).getDocuments{ snapShot, error in
            for doc in snapShot!.documents{
                print("나와라 ㅡㅡ : \(doc.documentID)")
                query.document("\(doc.documentID)").delete()
            }
        }
        self.realMemoList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
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
        return isFiltering ? self.searchMemoList.count : self.realMemoList.count
    }
}
