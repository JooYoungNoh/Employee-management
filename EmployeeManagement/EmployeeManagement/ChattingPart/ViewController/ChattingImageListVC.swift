//
//  ChattingImageListVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/09/19.
//

import UIKit
import SnapKit

class ChattingImageListVC: UIViewController {

    var viewModel = ChattingImageListVM()
    
    //컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let widthAndHeight: CGFloat = (UIScreen.main.bounds.width - 40) / 3.0
        layout.itemSize = CGSize(width: widthAndHeight, height: widthAndHeight)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        return collection
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ChattingImageListCell.self, forCellWithReuseIdentifier: ChattingImageListCell.identifier)
        uiCreate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: 액션 메소드
    @objc func doBack(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
    
    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션
        self.navigationItem.title = "모든 사진"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "CookieRun", size: 20)!]
        
        //내비게이션 바 버튼
        let backButton = UIBarButtonItem.init(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(doBack(_:)))
        self.navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = UIColor.black
        
        //컬랙션 뷰
        self.view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp
                .top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: collectionView 메소드
extension ChattingImageListVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.viewModel.cellInfo(collectionView: collectionView, indexPath: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection()
    }
    
    //셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       /* guard let uv = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC else { return }
        uv.companyNameOnTable = self.viewModel.dbmyCompany[indexPath.row]
        self.navigationController?.pushViewController(uv, animated: true)*/
    }    
}

