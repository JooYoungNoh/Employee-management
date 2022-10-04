//
//  Shopcell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/17.
//

import UIKit
import SnapKit

class Shopcell: UITableViewCell {
    static let identifier = "Shopcell"
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.init(name: "CookieRun", size: 14)
        nameLabel.textColor = UIColor.black
        
        return nameLabel
    }()
    let bossLabel: UILabel = {
        let bossLabel = UILabel()
        bossLabel.font = UIFont.init(name: "CookieRun", size: 14)
        bossLabel.textColor = UIColor.black
        bossLabel.textAlignment = .right
        
        return bossLabel
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bossLabel)
        contentView.addSubview(nameLabel)
        
        bossLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(self.snp.trailing).offset(-50)
            make.width.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.bossLabel.snp.leading).offset(-10)
        }
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
