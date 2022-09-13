//
//  ChattingRoomCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/30.
//

import UIKit

class ChattingRoomCell: UITableViewCell {
    static let identifier = "ChattingRoomCell"
    
    //내가 한 대화
    let rightTalkBox: BasePaddingLabel = {
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
        label.isHidden = true
        return label
    }()
    let rightTime: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont(name: "CookieRun", size: 10)
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    
    let rightcheck: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textColor = .blue
        label.textAlignment = .right
        label.font = UIFont(name: "CookieRun", size: 12)
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()
    
    //상대방이 한 대화
    let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    let leftnameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "CookieRun", size: 15)
        label.isHidden = true
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
        label.isHidden = true
        return label
    }()
    let leftTime: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "CookieRun", size: 10)
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    
    let leftcheck: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textColor = .blue
        label.textAlignment = .left
        label.font = UIFont(name: "CookieRun", size: 12)
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray6
        contentView.addSubview(rightTalkBox)
        contentView.addSubview(rightTime)
        contentView.addSubview(rightcheck)
        contentView.addSubview(leftImageView)
        contentView.addSubview(leftnameLabel)
        contentView.addSubview(leftTalkBox)
        contentView.addSubview(leftTime)
        contentView.addSubview(leftcheck)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //이미지 뷰 숨김 초기화
        self.rightTalkBox.isHidden = true
        self.rightTime.isHidden = true
        self.rightcheck.isHidden = true
        self.leftImageView.isHidden = true
        self.leftnameLabel.isHidden = true
        self.leftTalkBox.isHidden = true
        self.leftTime.isHidden = true
        self.leftcheck.isHidden = true
        
        self.rightTalkBox.text = ""
        self.rightTime.text = ""
        self.rightcheck.text = ""
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
