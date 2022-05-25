//
//  RequestJoincell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/25.
//

import UIKit

class RequestJoincell: UITableViewCell {
    static let identifier = "RequestJoincell"
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 20, y: 10, width: 200, height: 30)
        nameLabel.font = UIFont.init(name: "CookieRun", size: 14)
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .left
        
        return nameLabel
    }()
    
    let yesButton: UIButton = {
       let yesButton = UIButton()
        yesButton.frame = CGRect(x: 290, y: 10, width: 30, height: 30)
        yesButton.setTitle("수락", for: .normal)
        yesButton.setTitleColor(UIColor.black, for: .normal)
        yesButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 14)
        
        return yesButton
    }()
    
    let noButton: UIButton = {
       let noButton = UIButton()
        noButton.frame = CGRect(x: 330, y: 10, width: 30, height: 30)
        noButton.setTitle("거절", for: .normal)
        noButton.setTitleColor(UIColor.black, for: .normal)
        noButton.titleLabel?.font = UIFont.init(name: "CookieRun", size: 14)
        
        return noButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(noButton)
        contentView.addSubview(yesButton)
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
