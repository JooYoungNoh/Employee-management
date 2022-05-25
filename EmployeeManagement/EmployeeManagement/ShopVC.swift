//
//  ShopVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/17.
//

import UIKit
import FirebaseFirestore

struct List{
    var name: String
    var businessType: String
    var company: String
    var phone: String
    var img: Bool
    var employeeCount: Int
}

class ShopVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
                    //업종, 회사명,사원수, 이미지 여부, 사장이름, 전화번호
    var shopList = [List]()
    var dataList = [List]()
    
    var getCompany: [String] = []     //사장인데 회사를 가지고 있냐 없냐
    
    var isFiltering: Bool{
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //화면 구성 객체
    var searchBarController = UISearchController(searchResultsController: nil)
    let tableview = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //내비게이션 아이템 UI
        self.navigationItem.title = "Shop"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 30)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.shopList.removeAll()
        self.dataList.removeAll()
        
        self.db.collection("shop").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for doc in snapshot!.documents{
                    self.shopList.append( List.init(
                        name: doc.data()["name"] as! String,
                        businessType: doc.data()["businessType"] as! String,
                        company: doc.data()["company"] as! String,
                        phone: doc.data()["phone"] as! String,
                        img: doc.data()["img"] as! Bool,
                        employeeCount: doc.data()["employeeCount"] as! Int))
                }
                self.uiDeployment()
                self.tableview.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //MARK: 테이블 뷰 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Shopcell.identifier, for: indexPath) as? Shopcell else { return  UITableViewCell() }
        
        let shopName = self.shopList[indexPath.row].company
        let shopBoss = self.shopList[indexPath.row].name
        
        if self.isFiltering == false {
            cell.nameLabel.text = shopName
            cell.bossLabel.text = shopBoss
        } else {
            cell.nameLabel.text = self.dataList[indexPath.row].company
            cell.bossLabel.text = self.dataList[indexPath.row].name
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //이동할 화면
        let nv = self.storyboard?.instantiateViewController(withIdentifier: "ShopInformationVC") as! ShopInformationVC
        
        //전달할 내용
        if self.isFiltering == false{
            nv.companyOnTable = self.shopList[indexPath.row].company
            nv.nameOnTable = self.shopList[indexPath.row].name
            nv.businessTypeOnTable = self.shopList[indexPath.row].businessType
            nv.phoneOnTable = self.shopList[indexPath.row].phone
            nv.imgOnTable = self.shopList[indexPath.row].img
            nv.employeeCountOnTable = self.shopList[indexPath.row].employeeCount
        } else {
            nv.companyOnTable = self.dataList[indexPath.row].company
            nv.nameOnTable = self.dataList[indexPath.row].name
            nv.businessTypeOnTable = self.dataList[indexPath.row].businessType
            nv.phoneOnTable = self.dataList[indexPath.row].phone
            nv.imgOnTable = self.dataList[indexPath.row].img
            nv.employeeCountOnTable = self.dataList[indexPath.row].employeeCount
            nv.navigationController?.isNavigationBarHidden = true
        }
        self.navigationController?.pushViewController(nv, animated: true)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.dataList.count : self.shopList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let csview = UIView()
        let listTitle = UILabel()
        let bossTitle = UILabel()
        
        csview.backgroundColor = UIColor.white
        
        listTitle.frame = CGRect(x: 20, y: 0, width: self.view.frame.width / 2, height: 30)
        listTitle.font = UIFont.init(name: "CookieRun", size: 20)
        listTitle.text = "Company"
        listTitle.textColor = UIColor.blue
        
        bossTitle.frame = CGRect(x: self.view.frame.width / 2 + 20, y: 0, width: 128, height: 30)
        bossTitle.font = UIFont.init(name: "CookieRun", size: 20)
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
        
        self.dataList = self.shopList.filter( { (list: List) -> Bool in
            return list.company.lowercased().contains(text.lowercased())
        })
        
        self.tableview.reloadData()
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
        self.shopList = []
        
        //새로고침 시 갱신되어야 할 내용들
        self.db.collection("shop").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for doc in snapshot!.documents{
                    self.shopList.append( List.init(
                        name: doc.data()["name"] as! String,
                        businessType: doc.data()["businessType"] as! String,
                        company: doc.data()["company"] as! String,
                        phone: doc.data()["phone"] as! String,
                        img: doc.data()["img"] as! Bool,
                        employeeCount: doc.data()["employeeCount"] as! Int))
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
        let actionsheet = UIAlertController(title: nil, message: "선택해주세요.", preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "회사 가입신청", style: .default) { (_) in
            self.db.collection("shop").whereField("phone", isEqualTo: self.appDelegate.phoneInfo!).getDocuments { (snapshot, error) in
                for doc in snapshot!.documents{
                    self.getCompany.append(doc.documentID)
                }
                if self.getCompany == [] {
                    let alert = UIAlertController(title: nil, message: "회사를 등록하지 않았거나 CEO가 아닙니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } else {
                    guard let uv = self.storyboard?.instantiateViewController(withIdentifier: "RequestJoinVC") as? RequestJoinVC else { return }
                    uv.modalPresentationStyle = .fullScreen
                    
                    self.present(uv, animated: true)
                }
            }
        })
        //TODO: 추후에 설정 추가 예정
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionsheet, animated: true)
      
    }
    
    //MARK: 메소드
    func uiDeployment(){
        //서치바 UI
        self.searchBarController.searchBar.placeholder = "회사명을 입력해주세요."
        self.searchBarController.obscuresBackgroundDuringPresentation = false
        self.searchBarController.searchResultsUpdater = self
        
        //테이블 뷰 UI
        self.tableview.frame = CGRect(x: 0, y:  self.navigationController!.navigationBar.frame.height, width: self.view.frame.width, height: self.view.frame.height - self.navigationController!.navigationBar.frame.height - 90)
        self.tableview.backgroundColor = UIColor.white
        
        self.view.addSubview(tableview)
        
        //새로고침 UI
        self.tableview.refreshControl = UIRefreshControl()
        
        self.tableview.refreshControl?.tintColor = .systemGray
        
        self.tableview.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
}
