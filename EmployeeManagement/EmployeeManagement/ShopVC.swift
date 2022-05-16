//
//  ShopVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/17.
//

import UIKit
import FirebaseFirestore

class ShopVC: UIViewController {
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //화면 구성 객체
    let titleLabel = UILabel()
    let searchBar = UISearchBar()
    let tableview = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiDeployment()
    }
    
    func uiDeployment(){
        //타이틀 UI
        self.titleLabel.frame = CGRect(x: 20, y: 60, width: 80, height: 40)
        self.titleLabel.text = "Shop"
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.init(name: "Chalkboard SE", size: 25)
        
        self.view.addSubview(self.titleLabel)
        
        
        
        //서치 바 UI
        self.searchBar.frame = CGRect(x: 0, y: 105, width: self.view.frame.width, height: 45)
        self.searchBar.placeholder = "매장 검색"
        
        self.view.addSubview(self.searchBar)
        
        //테이블 뷰 UI
        self.tableview.frame = CGRect(x: 0, y: 150, width: self.view.frame.width, height: 654)
        self.tableview.backgroundColor = UIColor.systemGray5
        
        self.view.addSubview(tableview)
        
    }
    


}
