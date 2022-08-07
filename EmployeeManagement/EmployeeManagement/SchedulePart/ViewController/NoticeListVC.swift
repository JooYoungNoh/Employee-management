//
//  NoticeListVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/07.
//

import UIKit
import SnapKit

class NoticeListVC: UIViewController {
    
    var viewModel = NoticeListVM()

    let tableView = UITableView()       //테이블 뷰
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(NoticeListCell.self, forCellReuseIdentifier: NoticeListCell.identifier)
        self.uiCreate()
    }
    
    //MARK: 액션 메소드
    @objc func doBack(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
    
    @objc func addNotice(_ sender: UIBarButtonItem){
        self.viewModel.noAldaButton(uv: self)
    }
    
    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션 UI
        self.navigationItem.title = "공지사항"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        //내비게이션 바 버튼
        let noticeButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addNotice(_:)))
        let backButton = UIBarButtonItem.init(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(doBack(_:)))
        self.navigationItem.rightBarButtonItem = noticeButton
        self.navigationItem.leftBarButtonItem = backButton
        noticeButton.tintColor = UIColor.black
        backButton.tintColor = UIColor.black
        
        //테이블 뷰 UI
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(-90)
        }
    }
}

extension NoticeListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.viewModel.cellInfo(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
