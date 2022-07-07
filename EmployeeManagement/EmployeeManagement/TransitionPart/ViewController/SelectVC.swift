//
//  SelectVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/07.
//

import UIKit
import SnapKit

class SelectVC: UIViewController {

    var companyName: String = ""        //전 화면에서 받아오는 회사명
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.textAlignment = .center
        label.font = UIFont(name: "CookieRun", size: 40)
        return label
    }()
    
    let recipeButton: UIButton = {
        let button = UIButton()
        button.setTitle("레시피", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 30)
        button.layer.cornerRadius = 10
        button.alpha = 0.7
        return button
    }()
    
    let transitionButton: UIButton = {
        let button = UIButton()
        button.setTitle("인수인계", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 30)
        button.layer.cornerRadius = 10
        button.alpha = 0.7
        return button
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiCreate()
        
    }
    
    //MARK: 화면 메소드
    func uiCreate(){
        //회사명 레이블
        self.companyLabel.text = self.companyName
        self.view.addSubview(self.companyLabel)
        
        self.companyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        //레시피 버튼
        self.view.addSubview(self.recipeButton)
        
        self.recipeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.companyLabel.snp.bottom).offset(150)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        //인수인계 버튼
        self.view.addSubview(self.transitionButton)
        
        self.transitionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.recipeButton.snp.bottom).offset(50)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
}
