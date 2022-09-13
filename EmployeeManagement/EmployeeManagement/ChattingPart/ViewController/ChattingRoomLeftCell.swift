//
//  ChattingRoomLeftCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/09/13.
//

import UIKit

class ChattingRoomLeftCell: UITableViewCell {
    //상대방이 대화할 때
    static let identifier = "ChattingRoomLeftCell"
    
    let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let leftnameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "CookieRun", size: 15)
        return label
    }()
    let leftTalkBox: BasePaddingLabel = {
        let label = BasePaddingLabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "CookieRun", size: 16)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderWidth = 0
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    let leftTime: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "CookieRun", size: 10)
        label.numberOfLines = 2
        return label
    }()
    
    let leftcheck: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textColor = .blue
        label.textAlignment = .left
        label.font = UIFont(name: "CookieRun", size: 12)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray6
        contentView.addSubview(leftImageView)
        contentView.addSubview(leftnameLabel)
        contentView.addSubview(leftTalkBox)
        contentView.addSubview(leftTime)
        contentView.addSubview(leftcheck)
        
        self.leftImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(8)
            make.leading.equalTo(self.snp.leading).offset(10)
            make.width.height.equalTo(40)
        }
        self.leftnameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(5)
            make.leading.equalTo(self.leftImageView.snp.trailing).offset(5)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(150)
        }
        self.leftTalkBox.snp.makeConstraints { make in
            make.top.equalTo(self.leftnameLabel.snp.bottom).offset(5)
            make.leading.equalTo(self.leftImageView.snp.trailing).offset(5)
            make.height.greaterThanOrEqualTo(50)
            make.width.lessThanOrEqualTo(150)
        }
        self.leftTime.snp.makeConstraints { make in
            make.bottom.equalTo(self.leftTalkBox.snp.bottom)
            make.leading.equalTo(self.leftTalkBox.snp.trailing).offset(5)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        self.leftcheck.snp.makeConstraints { make in
            make.bottom.equalTo(self.leftTime.snp.top).offset(-2)
            make.leading.equalTo(self.leftTalkBox.snp.trailing).offset(5)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.leftnameLabel.text = ""
        self.leftTalkBox.text = ""
        self.leftTime.text = ""
        self.leftcheck.text = ""
    
        self.setNeedsLayout()
        self.layoutIfNeeded()
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
