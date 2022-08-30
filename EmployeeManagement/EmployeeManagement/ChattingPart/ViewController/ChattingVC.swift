//
//  ChattingVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/16.
//

import UIKit
import SnapKit

class ChattingVC: UIViewController {
    
    var viewModel = ChattingVM()
    
    let tableView = UITableView()                         //테이블 뷰
    
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
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(ChattingCell.self, forCellReuseIdentifier: ChattingCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let customTabBar = self.tabBarController as! CSTabBarController
        customTabBar.csView.isHidden = false
        self.uiCreate()
        self.viewModel.bringChattingList { completion in
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4){
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewModel.deleteListner()
    }
    
    //MARK: 액션 메소드
    @objc func addChatting(_ sender: UIBarButtonItem){
        self.viewModel.addChatting(uv: self)
    }
    
    @objc func goSetting(_ sender: UIBarButtonItem){
    }

    //MARK: 화면 메소드
    func uiCreate(){
        //서치바 UI
        self.searchBarController.searchBar.placeholder = "채팅방 이름을 입력해주세요."
        self.searchBarController.obscuresBackgroundDuringPresentation = false
        self.searchBarController.searchResultsUpdater = self
        
        //내비게이션
        self.navigationItem.title = "Chatting"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 30)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchBarController
        
        //내비게이션 바 버튼
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addChatting(_:)))
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goSetting(_:)))
        
        self.navigationItem.rightBarButtonItems = [settingButton, addButton]
        
        addButton.tintColor = UIColor.black
        settingButton.tintColor = UIColor.black
        
        //테이블 뷰 UI
        self.tableView.separatorStyle = .none
        
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(-90)
        }
    }
}

//MARK: 테이블 뷰 메소드
extension ChattingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.viewModel.cellInfo(tableView: tableView, indexPath: indexPath, isFiltering: self.isFiltering)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section, isFiltering: self.isFiltering)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.selectCell(uv: self, isFiltering: self.isFiltering, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let csview = UIView()
        let listTitle = UILabel()
        
        csview.backgroundColor = UIColor.white
        
        listTitle.frame = CGRect(x: 20, y: 0, width: self.view.frame.width / 2, height: 30)
        listTitle.font = UIFont.init(name: "CookieRun", size: 20)
        listTitle.text = "채팅목록"
        listTitle.textColor = UIColor.blue
        
        csview.addSubview(listTitle)
        return csview
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}

//MARK: 서치바 메소드
extension ChattingVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.searchBarfilter(searchController: searchController, tableView: self.tableView)
    }
}
