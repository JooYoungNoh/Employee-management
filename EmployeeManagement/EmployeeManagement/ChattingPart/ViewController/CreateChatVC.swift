//
//  CreateChatVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/21.
//

import UIKit
import SnapKit

class CreateChatVC: UIViewController {

    //뷰 모델
    var viewModel = CreateChatVM()
    
    //컬랙션 뷰 높이
    var changeHeight: Int = 0
    var heightConstraint: Constraint? = nil
    
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
        label.text = "대화상대 선택"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 20)
        return label
    }()
    
    //저장 버튼
    let saveButton: UIButton = {
        let save = UIButton()
        save.isHidden = true
        save.setTitle("Save", for: .normal)
        save.setTitleColor(UIColor.black, for: .normal)
        save.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return save
    }()
    
    //컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 50, height: 70)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    //테이블 뷰
    let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(CreateChatCVCell.self, forCellWithReuseIdentifier: CreateChatCVCell.identifier)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(CreateChatCell.self, forCellReuseIdentifier: CreateChatCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.uiCreate()
        self.viewModel.findEmployList(){ (completion2) in
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
            self.tableView.reloadData()
        }
    }
    
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @objc func dosave(_ sender: UIButton){
        // 컬랙션 뷰 크기 변경
        /*self.viewModel.collectionList.append(1)

        if self.changeHeight == 0 {
            self.changeHeight = 70
            self.heightConstraint?.update(offset: self.changeHeight)
            
            UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                self.view.layoutIfNeeded()
            }).startAnimation()
        } else {
            if self.viewModel.collectionList.count == 5 {
                self.viewModel.collectionList.removeAll()
                self.changeHeight = 0
                self.heightConstraint?.update(offset: self.changeHeight)
                
                UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                    self.view.layoutIfNeeded()
                }).startAnimation()
            }
        }
        collectionView.reloadData()*/
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
        
        //저장 버튼 UI
        saveButton.addTarget(self, action: #selector(dosave(_:)), for: .touchUpInside)
        self.view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(75)
            make.height.equalTo(40)
        }
        
        //컬렉션 뷰
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(15)
            make.trailing.equalToSuperview()
            self.heightConstraint = make.height.equalTo(0).constraint
        }
        
        //테이블 뷰
        self.tableView.separatorStyle = .none
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.collectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
}

//MARK: 컬렉션 뷰 메소드
extension CreateChatVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateChatCVCell.identifier, for: indexPath) as? CreateChatCVCell else { return UICollectionViewCell() }
    
        if self.viewModel.collectionList.count != 0 {
            cell.nameLabel.text = "실험중"
            cell.imageView.image = UIImage(named: "account")
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.collectionList.count
    }
}

//MARK: 테이블 뷰 메소드
extension CreateChatVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreateChatCell", for: indexPath) as? CreateChatCell else { return UITableViewCell() }
        
        //이름
        cell.nameLabel.text = self.viewModel.employeeRealResult[indexPath.row].name
        
        //프로필 이미지
        if self.viewModel.employeeRealResult[indexPath.row].profileImg == true {
            self.viewModel.employeeDownloadimage(imgView: cell.userImageView, phone: self.viewModel.employeeRealResult[indexPath.row].phone)
        } else {
            cell.userImageView.image = UIImage(named: "account")
        }
        
        //체크 표시
        if self.viewModel.collectionList.contains(indexPath.row) == true {
            cell.checkImageView.isHidden = false
        } else {
            cell.checkImageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell  = tableView.cellForRow(at: indexPath) as! CreateChatCell
        
        if cell.checkImageView.isHidden == true {
            cell.checkImageView.isHidden = false
            self.viewModel.collectionList.append(indexPath.row)
            
            if self.changeHeight == 0 {
                self.changeHeight = 70
                self.heightConstraint?.update(offset: self.changeHeight)
                
                UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                    self.view.layoutIfNeeded()
                }).startAnimation()
            }
            self.saveButton.isHidden = false
        } else {
            cell.checkImageView.isHidden = true
            if let index = self.viewModel.collectionList.firstIndex(of: indexPath.row){
                self.viewModel.collectionList.remove(at: index)
                
                if self.viewModel.collectionList.isEmpty == true {
                    self.changeHeight = 0
                    self.heightConstraint?.update(offset: self.changeHeight)
                    
                    UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                        self.view.layoutIfNeeded()
                    }).startAnimation()
                    
                    self.saveButton.isHidden = true
                }
            }
        }
        self.collectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.employeeRealResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let csview = UIView()
        let listTitle = UILabel()
        
        csview.backgroundColor = UIColor.white
        
        listTitle.frame = CGRect(x: 20, y: 0, width: self.view.frame.width / 2, height: 30)
        listTitle.font = UIFont.init(name: "CookieRun", size: 20)
        listTitle.text = "선택해주세요"
        listTitle.textColor = UIColor.blue
        
        csview.addSubview(listTitle)
        return csview
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}

