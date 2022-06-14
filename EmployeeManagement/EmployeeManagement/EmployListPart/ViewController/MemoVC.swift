//
//  MemoVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/15.
//

import UIKit
import SnapKit

class MemoVC: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .red
        return table
    }()
    
    var searchBarController = UISearchController(searchResultsController: nil)  //서치 바
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // uiCreate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiCreate()
    }
    
    func uiCreate(){
        //내비게이션
        self.navigationItem.title = "Memo"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchBarController
        
        //내비게이션 바 버튼
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addMemo(_:)))
        let backButton = UIBarButtonItem.init(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(doBack(_:)))
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = backButton
    
        addButton.tintColor = UIColor.black
        backButton.tintColor = UIColor.black
        
        //테이블 뷰 UI
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: 액션 메소드
    //메모 추가
    @objc func addMemo(_ sender: UIBarButtonItem){
        
    }
    //뒤로 가기
    @objc func doBack(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }

}
