//
//  MemoVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/15.
//

import UIKit
import SnapKit

class MemoVC: UIViewController {
    
    var viewModel = MemoVM()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        return table
    }()
    
    var searchBarController = UISearchController(searchResultsController: nil)  //서치 바
    
    var isFiltering: Bool{
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(MemoCell.self, forCellReuseIdentifier: MemoCell.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiCreate()
        self.viewModel.findMemo { (completion) in
            self.tableView.reloadData()
        }
    }
    
    func uiCreate(){
        //서치바 UI
        self.searchBarController.searchBar.placeholder = "키워드를 입력해주세요."
        self.searchBarController.obscuresBackgroundDuringPresentation = false
        self.searchBarController.searchResultsUpdater = self
        
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
        let nv = self.storyboard?.instantiateViewController(withIdentifier: "MemoWriteVC") as! MemoWriteVC
        nv.modalPresentationStyle = .fullScreen
        self.present(nv, animated: true)
    }
    //뒤로 가기
    @objc func doBack(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }

}

//MARK: 테이블 뷰 메소드
extension MemoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.identifier, for: indexPath) as? MemoCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        
        let date = Date(timeIntervalSince1970: self.viewModel.realMemoList[indexPath.row].date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let fixDate = "\(formatter.string(from: date))"
        
        if self.isFiltering == false {
            cell.titleLabel.text = self.viewModel.realMemoList[indexPath.row].title
            cell.dateLabel.text = fixDate
        } else {
            let date2 = Date(timeIntervalSince1970: self.viewModel.searchMemoList[indexPath.row].date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let fixDate2 = "\(formatter.string(from: date2))"
            cell.titleLabel.text = self.viewModel.searchMemoList[indexPath.row].title
            cell.dateLabel.text = fixDate2
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection(section: section, isFiltering: self.isFiltering)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //셀 클릭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nv = self.storyboard?.instantiateViewController(withIdentifier: "MemoReadVC") as! MemoReadVC
        
        //전달할 내용
        if self.isFiltering == false{
            nv.titleOnTable = self.viewModel.realMemoList[indexPath.row].title
            nv.dateOnTable = self.viewModel.realMemoList[indexPath.row].date
            nv.textOnTable = self.viewModel.realMemoList[indexPath.row].text
            nv.countOnTable = self.viewModel.realMemoList[indexPath.row].count
        } else {
            nv.titleOnTable = self.viewModel.searchMemoList[indexPath.row].title
            nv.dateOnTable = self.viewModel.searchMemoList[indexPath.row].date
            nv.textOnTable = self.viewModel.searchMemoList[indexPath.row].text
            nv.countOnTable = self.viewModel.searchMemoList[indexPath.row].count
            //nv.navigationController?.isNavigationBarHidden = true
        }
        
        self.navigationController?.pushViewController(nv, animated: true)
    }
    
    //삭제 기능
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.deleteMemo(tableView: tableView, forRowAt: indexPath, isFiltering: self.isFiltering)
        }
    }
}

extension MemoVC: UISearchResultsUpdating, UISearchBarDelegate {
    //MARK: 서치바 메소드
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.searchBarfilter(searchController: searchController, tableView: self.tableView)
    }
    
}
