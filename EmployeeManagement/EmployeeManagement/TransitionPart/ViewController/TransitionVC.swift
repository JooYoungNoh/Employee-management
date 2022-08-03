//
//  TransitionVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/16.
//

import UIKit
import SnapKit

class TransitionVC: UIViewController {
    
    //뷰 모델
    var viewModel = TransitionVM()
    
    //컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 190, height: 150)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.uiCreate()
        self.viewModel.findMyCompany{ completion in
            self.collectionView.reloadData()
        }
    }
    
    //MARK: 액션 메소드
    @objc func goSetting(_ sender: UIBarButtonItem){
        
    }
    
    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션
        self.navigationItem.title = "Transition"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 30)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //내비게이션 바 버튼
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goSetting(_:)))
        
        self.navigationItem.rightBarButtonItem = settingButton
        settingButton.tintColor = UIColor.black
        
        //컬렉션 뷰 UI
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
    
        
        cell.titleLabel.text = self.viewModel.dbmyCompany[indexPath.row]
        self.viewModel.companyDownloadimage(imgView: cell.imageView, company: self.viewModel.dbmyCompany[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dbmyCompany.count
    }
    
    //셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nv = storyboard?.instantiateViewController(withIdentifier: "SelectVC") as! SelectVC
        
        nv.companyName = self.viewModel.dbmyCompany[indexPath.row]
        
        self.navigationController?.pushViewController(nv, animated: true)
    }
    
    //타이틀
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
