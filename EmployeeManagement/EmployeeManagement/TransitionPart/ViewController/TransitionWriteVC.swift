//
//  TransitionWriteVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/13.
//

import UIKit
import SnapKit

class TransitionWriteVC: UIViewController {
    
    var naviTitle: String = " "         //전 화면에서 받아올 타이틀
    
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
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 20)
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        //button.isHidden = true
        return button
    }()
    
    //MARK: 메모 부분
    let memoLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0"
        label.font = UIFont(name: "CookieRun", size: 18)
        label.textAlignment = .right
        return label
    }()
    
    let writeTV: UITextView = {
       let write = UITextView()
        write.textColor = UIColor.black
        write.font = UIFont(name: "CookieRun", size: 18)
        write.textAlignment = .left
        write.backgroundColor = .systemGray6
        return write
    }()
    
    //MARK: 컬렉션 뷰 부분
    let pictureLabel: UILabel = {
        let label = UILabel()
        label.text = "사진"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 18)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 18)
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 150, height: 200)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()

    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(TransitionWriteCell.self, forCellWithReuseIdentifier: TransitionWriteCell.identifier)
        self.uiCreate()
    }
    
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }

    //MARK: 화면 메소드
    func uiCreate(){
        //닫기 버튼 UI
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        self.view.addSubview(self.closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        //타이틀 레이블 UI
        self.titleLabel.text = self.naviTitle
        self.view.addSubview(self.titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        //저장 버튼 UI
        self.view.addSubview(self.saveButton)
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        //메모레이블 UI
        self.view.addSubview(self.memoLabel)
        memoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.closeButton.snp.bottom).offset(15)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        //글자 수 레이블 UI
        self.view.addSubview(self.countLabel)
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(self.closeButton.snp.bottom).offset(15)
            make.width.equalTo(50)
            make.height.equalTo(30)

        }
        
        //메모 텍스트 뷰 UI
        self.view.addSubview(self.writeTV)
        writeTV.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(self.memoLabel.snp.bottom).offset(10)
            make.height.equalTo(390)
        }
        
        //사진레이블 UI
        self.view.addSubview(self.pictureLabel)
        pictureLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.writeTV.snp.bottom).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        //삭제버튼 UI
        self.view.addSubview(self.deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(self.writeTV.snp.bottom).offset(20)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        //추가버튼 UI
        self.view.addSubview(self.addButton)
        addButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.deleteButton.snp.leading)
            make.top.equalTo(self.writeTV.snp.bottom).offset(20)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        //컬렉션 뷰 UI
        self.view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.pictureLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    
    }
    
    //MARK: tap 제스쳐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension TransitionWriteVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransitionWriteCell.identifier, for: indexPath) as? TransitionWriteCell else { return UICollectionViewCell() }
        
        cell.imageView.image = UIImage(named: "recipe")
        cell.checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        
        return cell
    }
}
