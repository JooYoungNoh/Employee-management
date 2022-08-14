//
//  TimetableVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/09.
//

import UIKit
import SnapKit

class TimetableVC: UIViewController {

    var dateOnTable: String = ""                   //전 화면에서 받아오는 날짜 
    var companyOnTable: String = ""                //전 화면에서 받아오는 회사 이름
    
    var viewModel = TimetableVM()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 17)
        label.textColor = .blue
        label.text = "시간표"
        label.textAlignment = .center
        return label
    }()
    
    //MARK: 시간표 시간
    let tableTime9: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "09:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime10: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "10:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime11: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "11:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime12: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "12:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime13: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "13:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime14: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "14:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime15: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "15:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime16: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "16:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime17: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "17:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime18: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "18:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime19: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "19:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime20: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "20:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime21: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "21:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime22: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "22:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime23: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "23:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let tableTime0: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.text = "00:00"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    //컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        layout.itemSize = CGSize(width: 70, height: 590)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(TimetableCell.self, forCellWithReuseIdentifier: TimetableCell.identifier)
        self.uiCreate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.findName(companyOnTable: self.companyOnTable, dateOnTable: self.dateOnTable, timeLabel: self.timeLabel){ completion in
            self.collectionView.reloadData()
        }
    }
    
    //MARK: 액션 메소드
    @objc func addTimetable(_ sender: UIBarButtonItem){
        self.viewModel.addTimetable(uv: self, companyOnTable: self.companyOnTable, dateOnTable: self.dateOnTable)
    }
    
    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션
        self.navigationItem.title = self.dateOnTable
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        //내비게이션 바 버튼
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addTimetable(_:)))
        
        self.navigationItem.rightBarButtonItem = addButton
        addButton.tintColor = UIColor.black
        
        //개인 시간 정보
        self.view.addSubview(self.timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(30)
        }
        
        //화면 메소드 2
        self.uiCreateTwo()
        
        self.view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.timeLabel.snp.bottom)
            make.leading.equalTo(self.tableTime9.snp.trailing)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(-100)
        }
    }
    
    //MARK: 화면 메소드 2 (시간표 시간)
    func uiCreateTwo(){
        self.view.addSubview(self.tableTime9)
        tableTime9.snp.makeConstraints { make in
            make.top.equalTo(self.timeLabel.snp.bottom).offset(45)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }

        self.view.addSubview(self.tableTime10)
        tableTime10.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime9.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }

        self.view.addSubview(self.tableTime11)
        tableTime11.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime10.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime12)
        tableTime12.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime11.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime13)
        tableTime13.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime12.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime14)
        tableTime14.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime13.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime15)
        tableTime15.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime14.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime16)
        tableTime16.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime15.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime17)
        tableTime17.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime16.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime18)
        tableTime18.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime17.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime19)
        tableTime19.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime18.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime20)
        tableTime20.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime19.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime21)
        tableTime21.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime20.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime22)
        tableTime22.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime21.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime23)
        tableTime23.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime22.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tableTime0)
        tableTime0.snp.makeConstraints { make in
            make.top.equalTo(self.tableTime23.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
    }
}

//MARK: 컬랙션 뷰 메소드
extension TimetableVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.viewModel.cellInfo(collectionView: collectionView, indexPath: indexPath, timeLabel: self.timeLabel)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.scheduleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.selectCell(uv: self, indexPath: indexPath)
    }
}
