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
        self.tableView.register(EmployeeListCell.self, forCellReuseIdentifier: EmployeeListCell.identifier)
        self.uiCreate()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.viewModel.findList(){ (completion2) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
                self.tableView.reloadData()
            }
        }
    }
    
    //액션 메소드
    @objc func goSetting(_ sender: UIBarButtonItem){
        self.viewModel.doLogout(vc: self)
    }
    
    
    //MARK: 화면 UI 메소드
    func uiCreate(){
        //서치바 UI
        self.searchBarController.searchBar.placeholder = "이름을 입력해주세요."
        self.searchBarController.obscuresBackgroundDuringPresentation = false
        self.searchBarController.searchResultsUpdater = self
        
        //내비게이션
        self.navigationItem.title = "Employees"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 30)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchBarController
        
        //내비게이션 바 버튼
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goSetting(_:)))
        
        self.navigationItem.rightBarButtonItem = settingButton
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
extension EmployeeListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            return self.viewModel.numberOfRowsInSection(section: section, isFiltering: self.isFiltering)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeListCell.identifier, for: indexPath) as? EmployeeListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        if indexPath.section == 0{
            //프로필 이미지
            self.viewModel.findImage(imgView: cell.userImageView, phone: self.viewModel.myPhone)
            cell.nameLabel.text = self.viewModel.myName
            cell.commentLabel.text = self.viewModel.myComment
        } else {
            if self.isFiltering == false {
                //프로필 이미지
                cell.userImageView.image = nil
                if self.viewModel.employeeRealResult[indexPath.row].profileImg == true {
                    DispatchQueue.main.async {
                        self.viewModel.findImage(imgView: cell.userImageView, phone: self.viewModel.employeeRealResult[indexPath.row].phone)
                    }
                } else {
                    cell.userImageView.image = UIImage(named: "account")
                }
                cell.nameLabel.text = self.viewModel.employeeRealResult[indexPath.row].name
                cell.commentLabel.text = self.viewModel.employeeRealResult[indexPath.row].comment
            } else {
                //프로필 이미지
                cell.userImageView.image = nil
                if self.viewModel.searchResult[indexPath.row].profileImg == true {
                    DispatchQueue.main.async {
                        self.viewModel.findImage(imgView: cell.userImageView, phone: self.viewModel.searchResult[indexPath.row].phone)
                    }
                } else {
                    cell.userImageView.image = UIImage(named: "account")
                }
                
                cell.nameLabel.text = self.viewModel.searchResult[indexPath.row].name
                cell.commentLabel.text = self.viewModel.searchResult[indexPath.row].comment
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    //MARK: 셀 선택
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myNV = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileInfoVC") as! MyProfileInfoVC
        let nv = self.storyboard?.instantiateViewController(withIdentifier: "ProfileInfoVC") as! ProfileInfoVC
        
        
        if indexPath.section == 0{
            if let index = self.viewModel.userImageList.firstIndex(where: {$0.userPhone == self.viewModel.appDelegate.phoneInfo!}){
                myNV.imageOnTable = self.viewModel.userImageList[index].userImage
            }
            myNV.commentOnTable = self.viewModel.myComment
            myNV.nameOnTable = self.viewModel.myName
            myNV.modalPresentationStyle = .fullScreen
            
            self.present(myNV, animated: true)
            
        } else {
            if self.isFiltering == false{
                nv.imageChooseOnTable = self.viewModel.employeeRealResult[indexPath.row].profileImg
                nv.phoneOnTable = self.viewModel.employeeRealResult[indexPath.row].phone
                nv.commentOnTable = self.viewModel.employeeRealResult[indexPath.row].comment
                nv.nameOnTable = self.viewModel.employeeRealResult[indexPath.row].name
                nv.idOnTable = self.viewModel.employeeRealResult[indexPath.row].id
            } else {
                nv.imageChooseOnTable = self.viewModel.searchResult[indexPath.row].profileImg
                nv.phoneOnTable = self.viewModel.searchResult[indexPath.row].phone
                nv.commentOnTable = self.viewModel.searchResult[indexPath.row].comment
                nv.nameOnTable = self.viewModel.searchResult[indexPath.row].name
                nv.idOnTable = self.viewModel.searchResult[indexPath.row].id
            }
            nv.modalPresentationStyle = .fullScreen
            self.present(nv, animated: true)
        }
    }
    
    //MARK: 섹션 타이틀
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let csview = UIView()
        let listTitle = UILabel()
        
        csview.backgroundColor = UIColor.white
        if section == 0 {
            listTitle.frame = CGRect(x: 20, y: 0, width: self.view.frame.width / 2, height: 30)
            listTitle.font = UIFont.init(name: "CookieRun", size: 20)
            listTitle.text = "내 프로필"
            listTitle.textColor = UIColor.blue
            
            csview.addSubview(listTitle)
            return csview
        } else {
            listTitle.frame = CGRect(x: 20, y: 0, width: self.view.frame.width / 2, height: 30)
            listTitle.font = UIFont.init(name: "CookieRun", size: 20)
            listTitle.text = "동료 프로필"
            listTitle.textColor = UIColor.blue
            
            csview.addSubview(listTitle)
            return csview
        }
    }

}
//MARK: 서치바 메소드
extension EmployeeListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.searchBarfilter(searchController: searchController, tableView: self.tableView)
    }
}
