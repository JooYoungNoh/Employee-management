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
    var viewModel = SelectVM()
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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SelectCell.self, forCellReuseIdentifier: SelectCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.uiCreate()
        self.viewModel.findRecipe(naviTitle: self.companyName, completion: { (completion) in
            self.tableView.reloadData()
        })
        self.viewModel.findTransition(naviTitle: self.companyName, completion: { (completion) in
            self.tableView.reloadData()
        })
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
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchBarController
        
        //내비게이션 바 버튼
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addRecipe(_:)))
        self.navigationItem.backBarButtonItem?.tintColor = .black
        
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
        self.viewModel.doAdd(uv: self, companyName: self.companyName)
    }
}

//MARK: 테이블 뷰 메소드
extension SelectVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return self.viewModel.tableCellInfo(indexPath: indexPath, tableView: tableView, isFiltering: self.isFiltering)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection(section: section, isFiltering: self.isFiltering)
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
    
    //삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.deleteMemo(uv: self, tableView: tableView, forRowAt: indexPath, naviTitle: self.companyName, isFiltering: self.isFiltering)
        }
    }
    
    //셀 선택
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nv = storyboard?.instantiateViewController(withIdentifier: "TransitionInfoVC") as! TransitionInfoVC

        if self.isFiltering == false {
            if indexPath.section == 0 {
                nv.titleOnTable = self.viewModel.realRecipeList[indexPath.row].title
                nv.textOnTable = self.viewModel.realRecipeList[indexPath.row].text
                nv.countOnTable = self.viewModel.realRecipeList[indexPath.row].count
                nv.naviTitle = "레시피 정보"
                nv.companyName = self.companyName
                nv.checkTitle = self.viewModel.checkList
                nv.imageListOnTable = self.viewModel.realRecipeList[indexPath.row].imageList
            } else {
                nv.titleOnTable = self.viewModel.realTransitionList[indexPath.row].title
                nv.textOnTable = self.viewModel.realTransitionList[indexPath.row].text
                nv.countOnTable = self.viewModel.realTransitionList[indexPath.row].count
                nv.naviTitle = "인수인계 정보"
                nv.companyName = self.companyName
                nv.checkTitle = self.viewModel.checkList
                nv.imageListOnTable = self.viewModel.realTransitionList[indexPath.row].imageList
            }
        } else {
            if indexPath.section == 0 {
                nv.titleOnTable = self.viewModel.searchRecipeList[indexPath.row].title
                nv.textOnTable = self.viewModel.searchRecipeList[indexPath.row].text
                nv.countOnTable = self.viewModel.searchRecipeList[indexPath.row].count
                nv.naviTitle = "레시피 정보"
                nv.companyName = self.companyName
                nv.checkTitle = self.viewModel.checkList
                nv.imageListOnTable = self.viewModel.searchRecipeList[indexPath.row].imageList
            } else {
                nv.titleOnTable = self.viewModel.searchTransitionList[indexPath.row].title
                nv.textOnTable = self.viewModel.searchTransitionList[indexPath.row].text
                nv.countOnTable = self.viewModel.searchTransitionList[indexPath.row].count
                nv.naviTitle = "인수인계 정보"
                nv.companyName = self.companyName
                nv.checkTitle = self.viewModel.checkList
                nv.imageListOnTable = self.viewModel.searchTransitionList[indexPath.row].imageList
            }
        }
    
        self.navigationController?.pushViewController(nv, animated: true)
    }
}

//MARK: 서치바 메소드
extension SelectVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.searchBarfilter(searchController: searchController, tableView: self.tableView)
    }
}
