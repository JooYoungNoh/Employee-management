//
//  Shopcell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/17.
//

import UIKit

class Shopcell: UITableViewCell {
    static let identifier = "Shopcell"
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 20, y: 10, width: 200, height: 30)
        nameLabel.font = UIFont.init(name: "CookieRun", size: 14)
        nameLabel.textColor = UIColor.black
        
        return nameLabel
    }()
    let bossLabel: UILabel = {
        let bossLabel = UILabel()
        bossLabel.frame = CGRect(x: 240, y: 10, width: 100, height: 30)
        bossLabel.font = UIFont.init(name: "CookieRun", size: 14)
        bossLabel.textColor = UIColor.black
        bossLabel.textAlignment = .right
        
        return bossLabel
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bossLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
