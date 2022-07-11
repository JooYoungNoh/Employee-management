//
//  SelectVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/07.
//

import UIKit
import SnapKit

class SelectVC: UIViewController {

    var companyName: String = ""        //전 화면에서 받아오는 회사명
    let tableView = UITableView()       //테이블 뷰
    var searchBarController = UISearchController(searchResultsController: nil)  //서치 바
    
    var isFiltering: Bool{
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiCreate()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SelectCell.self, forCellReuseIdentifier: SelectCell.identifier)
        
    }
    
    //MARK: 화면 메소드
    func uiCreate(){
        //서치바 UI
        self.searchBarController.searchBar.placeholder = "키워드를 입력해주세요."
        self.searchBarController.obscuresBackgroundDuringPresentation = false
        self.searchBarController.searchResultsUpdater = self
        
        //내비게이션 UI
        self.navigationItem.title = self.companyName
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchBarController
        
        //내비게이션 바 버튼
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addRecipe(_:)))
        
        self.navigationItem.rightBarButtonItem = addButton
        addButton.tintColor = UIColor.black
        
        //테이블 뷰 UI
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(-90)
        }
    }
    
    //MARK: 엑션 메소드
    @objc func addRecipe(_ sender: UIBarButtonItem){
        
    }
}

//MARK: 테이블 뷰 메소드
extension SelectVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectCell.identifier, for: indexPath) as? SelectCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        if indexPath.section == 0 {
            cell.titleLabel.text = "섹션1"
            cell.dateLabel.text = "2020-06-17 07:18"
        } else {
            cell.titleLabel.text = "섹션2"
            cell.dateLabel.text = "2020-06-17 10:18"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //셀 타이틀
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let csview = UIView()
        let listTitle = UILabel()
        
        csview.backgroundColor = UIColor.white
        if section == 0 {
            listTitle.frame = CGRect(x: 20, y: 0, width: self.view.frame.width / 2, height: 30)
            listTitle.font = UIFont.init(name: "CookieRun", size: 20)
            listTitle.text = "레시피"
            listTitle.textColor = UIColor.blue
            
            csview.addSubview(listTitle)
            return csview
        } else {
            listTitle.frame = CGRect(x: 20, y: 0, width: self.view.frame.width / 2, height: 30)
            listTitle.font = UIFont.init(name: "CookieRun", size: 20)
            listTitle.text = "인수인계"
            listTitle.textColor = UIColor.blue
            
            csview.addSubview(listTitle)
            return csview
        }
    }
}

//MARK: 서치바 메소드
extension SelectVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
