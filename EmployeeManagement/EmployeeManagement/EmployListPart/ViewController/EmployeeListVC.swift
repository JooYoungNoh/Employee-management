//
//  EmployeeListVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/10.
//

import UIKit
import SnapKit

class EmployeeListVC: UIViewController {
    
    let tableView = UITableView()                         //테이블 뷰
    var searchBarController = UISearchController(searchResultsController: nil)  //서치 바

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //uiCreate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        uiCreate()
    }
    
    //액션 메소드
    @objc func goSetting(_ sender: UIBarButtonItem){
        
    }
    
    @objc func addFriend(_ sender: UIBarButtonItem){
        
    }
    
    func uiCreate(){
        //내비게이션
        self.navigationItem.title = "Employees"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 30)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchBarController
        
        //내비게이션 바 버튼
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goSetting(_:)))
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addFriend(_:)))
        
        self.navigationItem.rightBarButtonItems = [settingButton, addButton]
    
        addButton.tintColor = UIColor.black
        settingButton.tintColor = UIColor.black
        
        //테이블 뷰 UI
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(-90)
        }
        
    }

}
