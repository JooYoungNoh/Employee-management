//
//  ChattingCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/18.
//

import UIKit

class ChattingCell: UITableViewCell {

    static let identifier = "ChattingCell"
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CookieRun", size: 15)
        label.textColor = UIColor.black
        return label
    }()
    
    let userCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CookieRun", size: 12)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CookieRun", size: 10)
        label.textColor = UIColor.systemGray
        label.textAlignment = .right
        return label
    }()

    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CookieRun", size: 12)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(userCount)
        contentView.addSubview(dateLabel)
        contentView.addSubview(commentLabel)
        
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.width.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.userImageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(self.snp.trailing).offset(-115)
            make.height.equalTo(25)
        }
        
        userCount.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(5)
            make.width.lessThanOrEqualTo(30)
            make.height.equalTo(25)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.trailing.equalTo(self.snp.trailing).offset(-15)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.leading.equalTo(self.titleLabel.snp.leading)
            make.trailing.equalTo(self.snp.trailing).offset(-80)
            make.height.equalTo(25)
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
