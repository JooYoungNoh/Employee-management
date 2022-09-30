//
//  RequestJoincell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/25.
//

import UIKit
import SnapKit

class RequestJoincell: UITableViewCell {
    static let identifier = "RequestJoincell"
    var yesButtonAction : (() -> ())?
    var noButtonAction : (() -> ())?
    
    let company: UILabel = {
        let company = UILabel()
        company.font = UIFont.init(name: "CookieRun", size: 14)
        company.textColor = UIColor.black
        company.textAlignment = .left
        
        return company
    }()
    
    let name: UILabel = {
       let name = UILabel()
        name.font = UIFont.init(name: "CookieRun", size: 14)
        name.textColor = UIColor.black
        name.textAlignment = .left
        
        return name
    }()
    
    
    
    let yesButton: UIButton = {
       let yesButton = UIButton()
        yesButton.setTitle("수락", for: .normal)
        yesButton.setTitleColor(UIColor.black, for: .normal)
        yesButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 14)
        
        yesButton.layer.cornerRadius = 5
        yesButton.layer.borderWidth = 1
        yesButton.layer.borderColor = UIColor.black.cgColor
        
        return yesButton
    }()
    
    let noButton: UIButton = {
       let noButton = UIButton()
        noButton.setTitle("거절", for: .normal)
        noButton.setTitleColor(UIColor.black, for: .normal)
        noButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 14)
        
        noButton.layer.cornerRadius = 5
        noButton.layer.borderWidth = 1
        noButton.layer.borderColor = UIColor.black.cgColor
        
        return noButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.yesButton.addTarget(self, action: #selector(doYes(_:)), for: .touchUpInside)
        self.noButton.addTarget(self, action: #selector(doNo(_:)), for: .touchUpInside)
        
        contentView.addSubview(company)
        contentView.addSubview(noButton)
        contentView.addSubview(yesButton)
        contentView.addSubview(name)
        
        company.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(140)
        }
        
        noButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.width.equalTo(40)
        }
        
        yesButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.trailing.equalTo(noButton.snp.leading).offset(-10)
            make.width.equalTo(40)
        }
        
        name.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(company.snp.trailing).offset(10)
            make.trailing.equalTo(yesButton.snp.leading).offset(-10)
        }
    }
    
    @objc func doYes(_ sender: UIButton){
        yesButtonAction?()
    }
    
    @objc func doNo(_ sender: UIButton){
        noButtonAction?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
