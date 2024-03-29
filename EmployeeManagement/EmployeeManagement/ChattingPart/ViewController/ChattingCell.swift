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
        imageView.isHidden = true
        return imageView
    }()
    
    let userTwoImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    let userTwoImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    let userThreeImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 11
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    let userThreeImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 11
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    let userThreeImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 11
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    let userFourImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    let userFourImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    let userFourImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    let userFourImageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CookieRun", size: 15)
        label.textColor = .black
        return label
    }()
    
    let userCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CookieRun", size: 12)
        label.textColor = .systemGray
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CookieRun", size: 10)
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()
    
    let newMessageCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CookieRun", size: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        label.backgroundColor = .systemRed
        label.layer.cornerRadius = 11
        label.layer.borderWidth = 0
        label.layer.masksToBounds = true
        return label
    }()

    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CookieRun", size: 12)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userTwoImageView1)
        contentView.addSubview(userTwoImageView2)
        contentView.addSubview(userThreeImageView1)
        contentView.addSubview(userThreeImageView2)
        contentView.addSubview(userThreeImageView3)
        contentView.addSubview(userFourImageView1)
        contentView.addSubview(userFourImageView2)
        contentView.addSubview(userFourImageView3)
        contentView.addSubview(userFourImageView4)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(userCount)
        contentView.addSubview(commentLabel)
        contentView.addSubview(newMessageCount)
        
        //1명인 경우(총 2명)
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.width.equalTo(50)
        }
        
        //2명인 경우(총 3명)
        //좌상
        userTwoImageView1.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.width.height.equalTo(30)
        }
        //우하
        userTwoImageView2.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(30)
            make.leading.equalTo(self.snp.leading).offset(40)
            make.width.height.equalTo(30)
        }
        
        //3명인 경우(총 4명)
        //좌하
        userThreeImageView1.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.width.height.equalTo(28)
        }
        //우하
        userThreeImageView2.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.leading.equalTo(self.snp.leading).offset(42)
            make.width.height.equalTo(28)
        }
        //상 가운데
        userThreeImageView3.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.snp.leading).offset(31)
            make.width.height.equalTo(28)
        }
        
        //4명 이상(총 5명이상)
        //좌상
        userFourImageView1.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.width.height.equalTo(24)
        }
        //우상
        userFourImageView2.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.userFourImageView1.snp.trailing).offset(2)
            make.width.height.equalTo(24)
        }
        //좌하
        userFourImageView3.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.width.height.equalTo(24)
        }
        //우하
        userFourImageView4.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.leading.equalTo(self.userFourImageView2.snp.leading)
            make.width.height.equalTo(24)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.userImageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(self.snp.trailing).offset(-115)
            make.height.equalTo(25)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.trailing.equalTo(self.snp.trailing).offset(-15)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        
        userCount.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(5)
            make.trailing.equalTo(self.dateLabel.snp.leading).offset(-10)
            make.height.equalTo(25)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.leading.equalTo(self.titleLabel.snp.leading)
            make.trailing.equalTo(self.snp.trailing).offset(-80)
            make.height.equalTo(25)
        }
        
        newMessageCount.snp.makeConstraints { make in
            make.top.equalTo(self.commentLabel.snp.top)
            make.trailing.equalTo(self.dateLabel.snp.trailing)
            make.width.height.equalTo(22)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.userCount.text = ""
        self.titleLabel.text = ""
        self.commentLabel.text = ""
        self.dateLabel.text = ""
        self.newMessageCount.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
