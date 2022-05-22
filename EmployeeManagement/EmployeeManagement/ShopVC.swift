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
        
        self.db.collection("shop").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for doc in snapshot!.documents{
                    self.shopListName.append(doc.data()["company"] as! String)
                    self.shopListBoss.append(doc.data()["name"] as! String)
                }
                self.uiDeployment()
                
            } else {
                print(error!.localizedDescription)
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //전달할 내용
        let companyName = self.shopListName[indexPath.row]
        
        //이동할 화면
        let nv = self.storyboard?.instantiateViewController(withIdentifier: "ShopInformationVC") as! ShopInformationVC
        
        nv.companyOnTable = companyName
        
        self.navigationController?.pushViewController(nv, animated: true)

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
        bossTitle.text = "CEO"
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
  
        if appDelegate.jobInfo == "0" {
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "ShopAddVC")
            
            uv?.modalPresentationStyle = .fullScreen
            
            self.present(uv!, animated: true)
            
        } else {
            let alert = UIAlertController(title: nil, message: "Only the CEO can use it", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
        }
    }
    
    //새로고침 메소드
    @objc func pullToRefresh(_ sender: Any){
        self.shopListName = []
        self.shopListBoss = []
        
        //새로고침 시 갱신되어야 할 내용들
        self.db.collection("shop").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for doc in snapshot!.documents{
                    self.shopListName.append(doc.data()["company"] as! String)
                    self.shopListBoss.append(doc.data()["name"] as! String)
                }
                self.tableview.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        }
        
        //당겨서 새로고침 기능 종료
        self.tableview.refreshControl?.endRefreshing()
    }
    
    /*@objc func goSetting(_ sender: UIButton){
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      
    } */
    
    //MARK: 메소드
    func uiDeployment(){
        //타이틀 UI
        self.titleLabel.frame = CGRect(x: 20, y: 60, width: 80, height: 40)
        self.titleLabel.text = "Shop"
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.init(name: "Chalkboard SE", size: 25)
        
        self.view.addSubview(self.titleLabel)
        
        //매장 추가 버튼 UI
        self.addButton.frame = CGRect(x: 305, y: 65, width: 40, height: 40)
        self.addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        self.addButton.tintColor = UIColor.black
     
        self.addButton.addTarget(self, action: #selector(addShop(_:)), for: .touchUpInside)
        

        self.view.addSubview(self.addButton)
        
        //설정 버튼 UI
        self.settingButton.frame = CGRect(x: 340, y: 65, width: 40, height: 40)
        self.settingButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        
        self.settingButton.tintColor = UIColor.black
        
        self.settingButton.addTarget(self, action: #selector(addShop(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.settingButton)
        
        //서치 바 UI
        self.searchBar.frame = CGRect(x: 0, y: 105, width: self.view.frame.width, height: 45)
        self.searchBar.placeholder = "매장 검색"
        
        self.view.addSubview(self.searchBar)
        
        //테이블 뷰 UI
        self.tableview.frame = CGRect(x: 0, y: 150, width: self.view.frame.width, height: 604)
        self.tableview.backgroundColor = UIColor.systemGray5
        
        self.view.addSubview(tableview)
        
        //새로고침 UI
        self.tableview.refreshControl = UIRefreshControl()
        
        self.tableview.refreshControl?.tintColor = .systemGray
        
        self.tableview.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
}
