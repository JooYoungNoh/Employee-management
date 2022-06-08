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
    
    //닫기 버튼
    let closeButton: UIButton = {
        let close = UIButton()
        close.setTitle("Close", for: .normal)
        close.setTitleColor(UIColor.black, for: .normal)
        close.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return close
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print(nameOnTable)
        print(commentOnTable)
        print(imageChooseOnTable)
        print(phoneOnTable)
        uiCreate()
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
    }
    
    //MARK: 엑션 메소드
    @objc func doclose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}
