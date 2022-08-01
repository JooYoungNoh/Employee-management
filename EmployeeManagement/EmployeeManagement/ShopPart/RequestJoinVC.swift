//
//  RequestJoinVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/25.
//

import UIKit
import FirebaseFirestore

struct reList{
    var name: String
    var ceoPhone: String
    var phone: String
    var requestCompany: String
    var comment: String
    var id: String
    var profileImg: Bool
}

class RequestJoinVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let db = Firestore.firestore()
    
    var companyName = [reList]()
    var resultRequestJoin = [reList]()
    var employeeCount: Int = 0              //인원 수 받아오는 변수
    
    //화면 구성 객체
    let titleLabel = UILabel()
    let tableview = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(RequestJoincell.self, forCellReuseIdentifier: RequestJoincell.identifier)
        
        self.db.collectionGroup("requestJoin").getDocuments{ (snapshot, error) in
            for doc in snapshot!.documents{
                self.companyName.append(reList.init(name: doc.data()["name"] as! String, ceoPhone: doc.data()["ceoPhone"] as! String, phone: doc.data()["phone"] as! String, requestCompany: doc.data()["requestCompany"] as! String, comment: doc.data()["comment"] as! String, id: doc.data()["id"] as! String, profileImg: doc.data()["profileImg"] as! Bool))
            }
            while true{
                let index = self.companyName.firstIndex(where: {$0.ceoPhone == self.appDelegate.phoneInfo!})
                
                if index == nil {
                    break
                }
                self.resultRequestJoin.append(self.companyName[index!])
                self.companyName.remove(at: index!)
                
            }
            self.uiDeployment()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: 테이블 뷰 메소드
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultRequestJoin.count == 0{
            return 1
        } else{
            return self.resultRequestJoin.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestJoincell.identifier, for: indexPath) as? RequestJoincell else { return  UITableViewCell() }
        
        cell.yesButtonAction = { [unowned self] in
            let query = self.db.collection("shop").document("\(cell.company.text!)")
            
            //가입 요청 삭제
            query.collection("requestJoin").document("\(self.resultRequestJoin[indexPath.row].phone)").delete()
        
            //회사원 목록에 넣기
            query.collection("employeeControl").document("\(self.resultRequestJoin[indexPath.row].phone)").setData([
                "name" : "\(self.resultRequestJoin[indexPath.row].name)",
                "phone" : "\(self.resultRequestJoin[indexPath.row].phone)",
                "comment": "\(self.resultRequestJoin[indexPath.row].comment)",
                "id" : "\(self.resultRequestJoin[indexPath.row].id)",
                "profileImg" : self.resultRequestJoin[indexPath.row].profileImg
            ])
            
            //개인정보에 회사 이름 넣기
            self.db.collection("users").document("\(self.resultRequestJoin[indexPath.row].id)").collection("myCompany").document("\(self.resultRequestJoin[indexPath.row].requestCompany)").setData([
                "company" : "\(self.resultRequestJoin[indexPath.row].requestCompany)"
            ])
            
            //회사 인원 수 추가
            self.db.collection("shop").whereField("company", isEqualTo: cell.company.text!).getDocuments{ (snapshot, error) in
                if error == nil && snapshot != nil {
                    for doc in snapshot!.documents{
                        self.employeeCount = doc.data()["employeeCount"] as! Int
                    }
                } else {
                    print(error!.localizedDescription)
                }
                query.updateData(["employeeCount" : self.employeeCount + 1])
                
                self.resultRequestJoin.remove(at: indexPath.row)
                self.tableview.reloadData()
            }
        }
        
        cell.noButtonAction = { [unowned self] in
            let query = self.db.collection("shop").document("\(cell.company.text!)")
            
            //가입 요청 삭제
            query.collection("requestJoin").document("\(self.resultRequestJoin[indexPath.row].phone)").delete()
            
            self.resultRequestJoin.remove(at: indexPath.row)
            self.tableview.reloadData()
        }
        
        if self.resultRequestJoin.count == 0{
            cell.company.text = ""
            cell.name.text = "가입신청이 없습니다."
            cell.name.textColor = UIColor.red
            cell.name.frame = CGRect(x: self.view.frame.width / 2 - 65, y: 10, width: 130, height: 30)
            cell.yesButton.isHidden = true
            cell.noButton.isHidden = true
            
        } else {
            cell.company.text = self.resultRequestJoin[indexPath.row].requestCompany
            cell.name.text = self.resultRequestJoin[indexPath.row].name
            cell.yesButton.isHidden = false
            cell.noButton.isHidden = false
        }
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
