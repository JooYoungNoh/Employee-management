//
//  EmployeeListVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/10.
//

import UIKit
import SnapKit

class EmployeeListVC: UIViewController {
    
    var viewModel = EmployeeListVM()
    
    let tableView = UITableView()                         //테이블 뷰
    var searchBarController = UISearchController(searchResultsController: nil)  //서치 바

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(EmployeeListCell.self, forCellReuseIdentifier: EmployeeListCell.identifier)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.uiCreate()
        self.viewModel.findEmployList(){ (completion2) in
            self.tableView.reloadData()
        }
    }
    
    //액션 메소드
    @objc func goSetting(_ sender: UIBarButtonItem){
        
    }
    
    @objc func addFriend(_ sender: UIBarButtonItem){
        
    }
    
    //MARK: 화면 UI 메소드
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

//MARK: 테이블 뷰 메소드
extension EmployeeListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeListCell.identifier, for: indexPath) as? EmployeeListCell else { return UITableViewCell() }
        
        cell.userImageView.image = UIImage(named: "account")
        cell.nameLabel.text = self.viewModel.employeeList[indexPath.row].name
        cell.commentLabel.text = self.viewModel.employeeList[indexPath.row].comment
        
        return cell
    }
    
    
}
