//
//  ShopVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/17.
//

import UIKit
import FirebaseFirestore

class ShopVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var shopListName = [String]()
    var shopListBoss = [String]()
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //화면 구성 객체
    let titleLabel = UILabel()
    var searchBarController = UISearchController(searchResultsController: nil)
    let tableview = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //내비게이션 아이템 UI
        self.navigationItem.title = "Shop"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Chalkboard SE", size: 30)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Chalkboard SE", size: 20)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchBarController
        //바 버튼 아이템 UI
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goSetting(_:)))
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addShop(_:)))
        
        self.navigationItem.rightBarButtonItems = [settingButton, addButton]
    
        addButton.tintColor = UIColor.black
        settingButton.tintColor = UIColor.black
        
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
        
        csview.backgroundColor = UIColor.white
        
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
    
    //MARK: 서치바 메소드
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
    }
    
    //MARK: 액션 메소드
    @objc func addShop(_ sender: Any){
  
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
    
    @objc func goSetting(_ sender: Any){
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      
    }
    
    //MARK: 메소드
    func uiDeployment(){
        //서치바 UI
        self.searchBarController.searchBar.placeholder = "회사명을 입력해주세요."
        self.searchBarController.obscuresBackgroundDuringPresentation = false
        self.searchBarController.searchResultsUpdater = self
        
        //테이블 뷰 UI
        self.tableview.frame = CGRect(x: 0, y:  self.navigationController!.navigationBar.frame.height, width: self.view.frame.width, height: 658)
        self.tableview.backgroundColor = UIColor.white
        
        self.view.addSubview(tableview)
        
        //새로고침 UI
        self.tableview.refreshControl = UIRefreshControl()
        
        self.tableview.refreshControl?.tintColor = .systemGray
        
        self.tableview.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
}
