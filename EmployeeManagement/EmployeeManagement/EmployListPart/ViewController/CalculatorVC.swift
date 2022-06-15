//
//  CalculatorVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/16.
//

import UIKit
import SnapKit

class CalculatorVC: UIViewController {
    //닫기 버튼
    let closeButton: UIButton = {
        let close = UIButton()
        close.setTitle("Close", for: .normal)
        close.setTitleColor(UIColor.black, for: .normal)
        close.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return close
    }()
    
    //시급 레이블
    let money: UILabel = {
        let label = UILabel()
        label.text = "시급"
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 15)
        label.textAlignment = .left
        label.backgroundColor = .systemGray6
        return label
    }()
    

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        uiCreate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
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
        
        self.view.addSubview(money)
        
        money.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading).offset(100)
            make.top.equalTo(self.closeButton.snp.bottom).offset(200)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
    }
    
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }

}
