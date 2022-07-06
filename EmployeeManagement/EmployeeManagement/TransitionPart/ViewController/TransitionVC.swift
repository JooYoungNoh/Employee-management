//
//  TransitionVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/16.
//

import UIKit
import SnapKit

class TransitionVC: UIViewController {
    
    //컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 180, height: 120)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        return collection
    }()

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(TransitionCell.self, forCellWithReuseIdentifier: TransitionCell.identifier)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        uiCreate()
    }
    
    //MARK: 액션 메소드
    @objc func goSetting(_ sender: UIBarButtonItem){
        
    }
    
    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션
        self.navigationItem.title = "Recipe"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 30)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //내비게이션 바 버튼
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goSetting(_:)))
        
        self.navigationItem.rightBarButtonItem = settingButton
        settingButton.tintColor = UIColor.black
        
        //테이블 뷰 UI
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(-90)
        }
    }
}

//MARK: collectionView 메소드
extension TransitionVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransitionCell.identifier, for: indexPath) as? TransitionCell else { return UICollectionViewCell() }
    
        
        cell.titleLabel.text = "연습중"
        cell.imageView.image = UIImage(named: "recipe")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        
        let listTitle = UILabel()
        listTitle.frame = CGRect(x: 20, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        listTitle.font = UIFont.init(name: "CookieRun", size: 20)
        listTitle.text = "회사를 선택해주세요"
        listTitle.textColor = UIColor.blue
        
        headerView.addSubview(listTitle)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
    
}
/*
let csview = UIView()
let listTitle = UILabel()

csview.backgroundColor = UIColor.white
if section == 0 {
    listTitle.frame = CGRect(x: 20, y: 0, width: self.view.frame.width / 2, height: 30)
    listTitle.font = UIFont.init(name: "CookieRun", size: 20)
    listTitle.text = "내 프로필"
    listTitle.textColor = UIColor.blue
    
    csview.addSubview(listTitle)
    return csview
} else {
    listTitle.frame = CGRect(x: 20, y: 0, width: self.view.frame.width / 2, height: 30)
    listTitle.font = UIFont.init(name: "CookieRun", size: 20)
    listTitle.text = "동료 프로필"
    listTitle.textColor = UIColor.blue
    
    csview.addSubview(listTitle)
    return csview
}*/
