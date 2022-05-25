//
//  RequestJoinVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/25.
//

import UIKit
import FirebaseFirestore

class RequestJoinVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let db = Firestore.firestore()
    
    var companyName = [String]()
    var requestName = [String]()
    
    //화면 구성 객체
    let titleLabel = UILabel()
    let tableview = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(RequestJoincell.self, forCellReuseIdentifier: RequestJoincell.identifier)

        uiDeployment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.phoneInfo = "01031201798"
        
    }
    
    //MARK: 테이블 뷰 메소드
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestJoincell.identifier, for: indexPath) as? RequestJoincell else { return  UITableViewCell() }
        cell.company.text = "실험용1"
        cell.name.text = "이름용"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let csview = UIView()
        let companyLabel = UILabel()
        let nameLabel = UILabel()
        let selectLabel = UILabel()
        
        csview.backgroundColor = UIColor.systemGray5
        
        companyLabel.frame = CGRect(x: 20, y: 0, width: 100, height: 30)
        companyLabel.font = UIFont.init(name: "CookieRun", size: 20)
        companyLabel.text = "회사명"
        companyLabel.textColor = UIColor.blue
        
        nameLabel.frame = CGRect(x: 140, y: 0, width: 120, height: 30)
        nameLabel.font = UIFont.init(name: "CookieRun", size: 20)
        nameLabel.text = "이름"
        nameLabel.textColor = UIColor.blue
        nameLabel.textAlignment = .left
            
        selectLabel.frame = CGRect(x: self.view.frame.width / 2 + 20, y: 0, width: 128, height: 30)
        selectLabel.font = UIFont.init(name: "CookieRun", size: 20)
        selectLabel.text = "선택"
        selectLabel.textColor = UIColor.blue
        selectLabel.textAlignment = .right
        
        csview.addSubview(companyLabel)
        csview.addSubview(nameLabel)
        csview.addSubview(selectLabel)
        
        return csview

    
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @objc func doYes(_ sender: UIButton){
        print("Yes")
    }
    
    @objc func doNo(_ sender: UIButton){
        
    }
    
    //MARK: 화면 구성 메소드
    func uiDeployment(){
        //닫기 버튼 UI
        let closeButton = UIButton()
        
        closeButton.frame = CGRect(x: 0, y: 50, width: 80, height: 40)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        
        self.view.addSubview(closeButton)
        
        //타이틀 레이블 UI
        self.titleLabel.frame = CGRect(x: self.view.frame.width / 2 - 130, y: 100, width: 260, height: 40)
        
        self.titleLabel.text = "My Company Request Join"
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.init(name: "CookieRun", size: 20)
        
        self.view.addSubview(self.titleLabel)
        
        //테이블 뷰 UI
        self.tableview.frame = CGRect(x: 0, y: 150, width: self.view.frame.width, height: self.view.frame.height - 150)
        self.tableview.backgroundColor = UIColor.white
        
        self.view.addSubview(tableview)
        
    }

}
