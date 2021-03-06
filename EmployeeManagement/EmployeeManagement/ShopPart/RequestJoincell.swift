//
//  RequestJoincell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/25.
//

import UIKit

class RequestJoincell: UITableViewCell {
    static let identifier = "RequestJoincell"
    var yesButtonAction : (() -> ())?
    var noButtonAction : (() -> ())?
    
    let company: UILabel = {
        let company = UILabel()
        company.frame = CGRect(x: 20, y: 10, width: 100, height: 30)
        company.font = UIFont.init(name: "CookieRun", size: 14)
        company.textColor = UIColor.black
        company.textAlignment = .left
        
        return company
    }()
    
    let name: UILabel = {
       let name = UILabel()
        name.frame = CGRect(x: 140, y: 10, width: 130, height: 30)
        name.font = UIFont.init(name: "CookieRun", size: 14)
        name.textColor = UIColor.black
        name.textAlignment = .left
        
        return name
    }()
    
    
    
    let yesButton: UIButton = {
       let yesButton = UIButton()
        yesButton.frame = CGRect(x: 280, y: 10, width: 40, height: 30)
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
        noButton.frame = CGRect(x: 330, y: 10, width: 40, height: 30)
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
        contentView.addSubview(name)
        contentView.addSubview(noButton)
        contentView.addSubview(yesButton)
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
