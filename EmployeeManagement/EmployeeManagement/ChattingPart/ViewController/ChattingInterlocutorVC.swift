//
//  ChattingInterlocutorVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/09/26.
//

import UIKit
import SnapKit

class ChattingInterlocutorVC: UIViewController {
    
    var viewModel = ChattingInterlocutorVM()
    var phoneListOnTable: [String] = []             //전 화면에서 가져온 채팅방 맴버
    var userImageList: [roomImageSave] = []         //전 화면에서 가져온 채팅방 맴버 사진
    
    //닫기 버튼
    let closeButton: UIButton = {
        let close = UIButton()
        close.setTitle("Close", for: .normal)
        close.setTitleColor(UIColor.black, for: .normal)
        close.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return close
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "초대할 대화상대 선택"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 20)
        return label
    }()
    
    //테이블 뷰
    let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(ChattingInterlocutorCell.self, forCellReuseIdentifier: ChattingInterlocutorCell.identifier)
        self.uiCreate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }

    //MARK: 화면 메소드
    func uiCreate(){
        //닫기 버튼 UI
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        //타이틀 UI
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        //테이블 뷰
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
}

extension ChattingInterlocutorVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.viewModel.cellInfoTable(tableView: tableView, indexPath: indexPath, phoneListOntable: self.phoneListOnTable, userImageList: self.userImageList)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.phoneListOnTable.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
