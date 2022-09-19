//
//  ChattingImageInfoVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/09/19.
//

import UIKit
import SnapKit

class ChattingImageInfoVC: UIViewController {

    var nameOnTable: String = ""
    var dateOnTable: String = ""
    var imageOnTable: UIImage? = nil
    
    let nvView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = CGSize(width: 150, height: 50)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = UIFont(name: "CookieRun", size: 15)
        return label
    }()
    
    let chatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiCreate()
    }
    
    //MARK: 액션 메소드
    
    //MARK: 화면 메소드
    func uiCreate(){
        //내비게이션
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.title = ""
        
        //타이틀 뷰
        self.navigationItem.titleView = self.nvView
        
        //타이틀 뷰 안에 레이블들
        print(self.nameOnTable)
        self.nameLabel.text = self.nameOnTable
        self.nvView.addSubview(self.nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(25)
        }
        
        self.dateLabel.text = self.dateOnTable
        self.nvView.addSubview(self.dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(5)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        //이미지 뷰
        self.chatImageView.image = self.imageOnTable
        self.view.addSubview(self.chatImageView)
        chatImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(UIScreen.main.bounds.width - 20)
        }

    }

}
