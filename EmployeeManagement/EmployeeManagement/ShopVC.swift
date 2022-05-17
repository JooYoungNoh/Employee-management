//
//  ShopVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/17.
//

import UIKit
import FirebaseFirestore

class ShopVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var shopListName = [String]()
    var shopListBoss = [String]()
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //화면 구성 객체
    let titleLabel = UILabel()
    let addButton = UIButton()
    let settingButton = UIButton()
    let searchBar = UISearchBar()
    let tableview = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource =  self
        self.tableview.register(Shopcell.self, forCellReuseIdentifier: Shopcell.identifier)
        self.tableview.rowHeight = 50
        
        self.db.collection("shop").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for doc in snapshot!.documents{
                    self.shopListName.append(doc.data()["name"] as! String)
                    self.shopListBoss.append(doc.data()["boss"] as! String)
                }
                self.uiDeployment()
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: 테이블 뷰 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Shopcell.identifier, for: indexPath) as? Shopcell else { return  UITableViewCell() }
        
        let shopName = self.shopListName[indexPath.row]
        let shopBoss = self.shopListBoss[indexPath.row]
        
        cell.nameLabel.text = shopName
        cell.bossLabel.text = shopBoss
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopListName.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let csview = UIView()
        let listTitle = UILabel()
        let bossTitle = UILabel()
        
        csview.backgroundColor = UIColor.systemGray5
        
        listTitle.frame = CGRect(x: 20, y: 0, width: self.view.frame.width / 2, height: 30)
        listTitle.font = UIFont.init(name: "Chalkboard SE", size: 20)
        listTitle.text = "Company"
        listTitle.textColor = UIColor.blue
        
        bossTitle.frame = CGRect(x: self.view.frame.width / 2 + 20, y: 0, width: 128, height: 30)
        bossTitle.font = UIFont.init(name: "Chalkboard SE", size: 20)
        bossTitle.text = "Boss"
        bossTitle.textColor = UIColor.blue
        bossTitle.textAlignment = .right
        
        csview.addSubview(listTitle)
        csview.addSubview(bossTitle)
        
        return csview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    //MARK: 액션 메소드
    @objc func addShop(_ sender: UIButton){
        
    }
    
    @objc func goSetting(_ sender: UIButton){
        
    }
    
    //MARK: 메소드
    func uiDeployment(){
        //타이틀 UI
        self.titleLabel.frame = CGRect(x: 20, y: 60, width: 80, height: 40)
        self.titleLabel.text = "Shop"
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.init(name: "Chalkboard SE", size: 25)
        
        self.view.addSubview(self.titleLabel)
        
        //매장 추가 버튼 UI
        self.addButton.frame = CGRect(x: 305, y: 70, width: 30, height: 30)
        self.addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        self.addButton.tintColor = UIColor.black
        
        self.view.addSubview(self.addButton)
        
        //설정 버튼 UI
        self.settingButton.frame = CGRect(x: 340, y: 70, width: 30, height: 30)
        self.settingButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        self.settingButton.tintColor = UIColor.black
        
        self.view.addSubview(self.settingButton)
        
        //서치 바 UI
        self.searchBar.frame = CGRect(x: 0, y: 105, width: self.view.frame.width, height: 45)
        self.searchBar.placeholder = "매장 검색"
        
        self.view.addSubview(self.searchBar)
        
        //테이블 뷰 UI
        self.tableview.frame = CGRect(x: 0, y: 150, width: self.view.frame.width, height: 604)
        self.tableview.backgroundColor = UIColor.systemGray5
        
        self.view.addSubview(tableview)
        
    }
    


}
