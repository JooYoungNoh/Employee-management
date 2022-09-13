//
//  ChattingRoomCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/30.
//

import UIKit

class ChattingRoomCell: UITableViewCell {
    //내가 대화할 때
    static let identifier = "ChattingRoomCell"
    
    let rightTalkBox: BasePaddingLabel = {
        let label = BasePaddingLabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "CookieRun", size: 15)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderWidth = 0
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    let rightTime: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont(name: "CookieRun", size: 10)
        label.numberOfLines = 2
        return label
    }()
    
    let rightcheck: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textColor = .blue
        label.textAlignment = .right
        label.font = UIFont(name: "CookieRun", size: 12)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray6
        contentView.addSubview(rightTalkBox)
        contentView.addSubview(rightTime)
        contentView.addSubview(rightcheck)
        
        self.rightTalkBox.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.width.lessThanOrEqualTo(200)
        }
        
        self.rightTime.snp.makeConstraints { make in
            make.bottom.equalTo(self.rightTalkBox.snp.bottom)
            make.trailing.equalTo(self.rightTalkBox.snp.leading).offset(-5)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        self.rightcheck.snp.makeConstraints { make in
            make.bottom.equalTo(self.rightTime.snp.top).offset(-2)
            make.trailing.equalTo(self.rightTalkBox.snp.leading).offset(-5)
            make.height.equalTo(10)
            make.width.equalTo(30)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.rightTalkBox.text = ""
        self.rightTime.text = ""
        self.rightcheck.text = ""
    
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
