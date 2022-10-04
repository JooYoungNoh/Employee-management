//
//  ChattingRoomLeftPictureCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/09/18.
//

import UIKit

class ChattingRoomLeftPictureCell: UITableViewCell {

    //상대방이 보낸 메시지
    static let identifier = "ChattingRoomLeftPictureCell"
    
    let stackView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
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
    let leftTalkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
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
        contentView.addSubview(self.stackView)
        
        self.stackView.addSubview(leftImageView)
        self.stackView.addSubview(leftnameLabel)
        self.stackView.addSubview(leftTalkImageView)
        self.stackView.addSubview(leftTime)
        self.stackView.addSubview(leftcheck)
        
        self.stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        self.leftImageView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.top).offset(8)
            make.leading.equalTo(stackView.snp.leading).offset(10)
            make.width.height.equalTo(40)
        }
        self.leftnameLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.top).offset(5)
            make.leading.equalTo(self.leftImageView.snp.trailing).offset(5)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(150)
        }
        self.leftTalkImageView.snp.makeConstraints { make in
            make.top.equalTo(self.leftnameLabel.snp.bottom).offset(5)
            make.leading.equalTo(self.leftImageView.snp.trailing).offset(5)
            make.width.height.equalTo(200)
        }
        self.leftTime.snp.makeConstraints { make in
            make.bottom.equalTo(self.leftTalkImageView.snp.bottom)
            make.leading.equalTo(self.leftTalkImageView.snp.trailing).offset(5)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        self.leftcheck.snp.makeConstraints { make in
            make.bottom.equalTo(self.leftTime.snp.top).offset(-2)
            make.leading.equalTo(self.leftTalkImageView.snp.trailing).offset(5)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.leftnameLabel.text = ""
        self.leftTime.text = ""
        self.leftcheck.text = ""
        self.leftTalkImageView.image = UIImage(named: "prepareImage")
        
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
