//
//  EmployeeListCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/03.
//

import UIKit
import SnapKit

class EmployeeListCell: UITableViewCell {
    
    static let identifier = "EmployeeListCell"
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.init(name: "CookieRun", size: 16)
        nameLabel.textColor = UIColor.black
        
        return nameLabel
    }()

    let commentLabel: UILabel = {
        let comment = UILabel()
        comment.font = UIFont.init(name: "CookieRun", size: 13)
        comment.textColor = UIColor.systemGray
        
        return comment
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(commentLabel)
        
        userImageView.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.userImageView.snp.trailing).offset(10)
            make.top.equalTo(8)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.nameLabel.snp.leading)
            make.top.equalTo(self.nameLabel.snp.bottom)
            make.width.equalTo(260)
            make.height.equalTo(20)
        }
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
