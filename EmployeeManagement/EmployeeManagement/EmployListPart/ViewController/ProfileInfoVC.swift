//
//  ProfileInfoVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/09.
//

import UIKit

class ProfileInfoVC: UIViewController {
    
    var nameOnTable: String = ""                //전 화면 셀에 있는 이름
    var commentOnTable: String = ""             //전 회면 셀에 있는 코멘트
    var phoneOnTable: String = ""               //전 화면 셀에 있는 번호
    var imageChooseOnTable: Bool = false        //전 화면 셀에 있는 사진유무
    
    var viewModel = ProfileVM()                 //프로필 뷰모델
    
    //닫기 버튼
    let closeButton: UIButton = {
        let close = UIButton()
        close.setTitle("Close", for: .normal)
        close.setTitleColor(UIColor.black, for: .normal)
        close.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return close
    }()
    //프로필 이미지
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 80
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    //이름
    let nameLabel: UILabel = {
       let name = UILabel()
        name.textColor = UIColor.black
        name.font = UIFont(name: "CookieRun", size: 30)
        name.textAlignment = .center
        name.backgroundColor = .systemGray6
        return name
    }()
    //코멘트
    let commentLabel: UILabel = {
        let comment = UILabel()
        comment.textColor = UIColor.black
        comment.alpha = 0.5
        comment.font = UIFont(name: "CookieRun", size: 18)
        comment.textAlignment = .center
        comment.backgroundColor = .systemGray6
        comment.numberOfLines = 0
        return comment
    }()

    //컬렉션 뷰 위쪽 선 표시
    let commentUnderView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    //버튼들 위쪽 선 표시
    let buttonUpView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //나랑 같은 회사 레이블
    let sameCompony: UILabel = {
        let label = UILabel()
        label.text = "나랑 같은 회사 ↓"
        label.textColor = UIColor.blue
        label.font = UIFont(name: "CookieRun", size: 18)
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        return label
    }()

    // 채팅 버튼
    let chatButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chat"), for: .normal)
        button.tintColor = .black
        return button
    }()
    let chatLabel: UILabel = {
        let label = UILabel()
        label.text = "1대1 채팅"
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        label.font = UIFont(name: "CookieRun", size: 15)
        return label
    }()

    //컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 120)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemGray6
        return collection
    }()

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ProfileInfoCVCell.self, forCellWithReuseIdentifier: ProfileInfoCVCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .systemGray6
        uiCreate()
        self.viewModel.findMyCompany(phoneOnTable: self.phoneOnTable) { completion in
            self.collectionView.reloadData()
        }
    }
    
    //MARK: 화면 UI 메소드
    func uiCreate(){
        //닫기 버튼 UI
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        //MARK: 정보 부분
        //프로필 이미지 UI
        self.viewModel.findProfileImage(phoneOnTable: self.phoneOnTable, imageChooseOnTable: self.imageChooseOnTable, profileView: self.profileImage)
        self.view.addSubview(profileImage)
        
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
            make.width.height.equalTo(200)
        }
        //이름 UI
        self.nameLabel.text = self.nameOnTable
        self.view.addSubview(self.nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.profileImage.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        //코멘트 UI
        self.commentLabel.text = self.commentOnTable
        self.view.addSubview(self.commentLabel)
        
        commentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.lessThanOrEqualTo(60)
        }
        
        //MARK: 버튼 선택 부분
        //채팅 UI
        self.view.addSubview(chatLabel)
        chatLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        chatButton.addTarget(self, action: #selector(doChat(_:)), for: .touchUpInside)
        self.view.addSubview(chatButton)
        chatButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.chatLabel.snp.centerX)
            make.bottom.equalTo(self.chatLabel.snp.top).offset(-5)
            make.width.height.equalTo(30)
        }
        //버튼 위쪽 선 UI
        self.view.addSubview(self.buttonUpView)
        buttonUpView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalTo(self.chatButton.snp.top).offset(-15)
        }
        
        //MARK: 컬렉션 뷰
        self.view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.buttonUpView.snp.top).offset(-20)
            make.height.equalTo(150)
        }
        
        //컬렉션 뷰 위 선 UI
        self.view.addSubview(self.commentUnderView)
        commentUnderView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalTo(self.collectionView.snp.top).offset(-20)
        }
        
        //나랑 같은 회사 레이블 UI
        self.view.addSubview(self.sameCompony)
        sameCompony.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.bottom.equalTo(self.commentUnderView.snp.top).offset(-5)
            make.leading.equalTo(self.closeButton.snp.leading)
        }
    
    }
    
    //MARK: 엑션 메소드
    @objc func doclose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func doChat(_ sender: UIButton){
        
    }

}
//MARK: collectionView 메소드
extension ProfileInfoVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileInfoCVCell.identifier, for: indexPath) as? ProfileInfoCVCell else { return UICollectionViewCell() }
    
        
        cell.titleLabel.text = self.viewModel.sortedCompany[indexPath.row]
        self.viewModel.companyDownloadimage(imgView: cell.imageView, company: cell.titleLabel.text!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.sortedCompany.count
    }
}
