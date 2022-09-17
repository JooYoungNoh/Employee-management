//
//  ChattingRoomRightPictureCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/09/18.
//

import UIKit

class ChattingRoomRightPictureCell: UITableViewCell {

    //내가 사진 보낸 사진
    static let identifier = "ChattingRoomRightPictureCell"
    
    let stackView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    let rightTalkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        contentView.addSubview(self.stackView)
        
        self.stackView.addSubview(rightTalkImageView)
        self.stackView.addSubview(rightTime)
        self.stackView.addSubview(rightcheck)
        
        self.stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        self.rightTalkImageView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.top).offset(10)
            make.trailing.equalTo(stackView.snp.trailing).offset(-10)
            make.width.height.equalTo(250)
        }
        
        self.rightTime.snp.makeConstraints { make in
            make.bottom.equalTo(self.rightTalkImageView.snp.bottom)
            make.trailing.equalTo(self.rightTalkImageView.snp.leading).offset(-5)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        self.rightcheck.snp.makeConstraints { make in
            make.bottom.equalTo(self.rightTime.snp.top).offset(-2)
            make.trailing.equalTo(self.rightTalkImageView.snp.leading).offset(-5)
            make.height.equalTo(10)
            make.width.equalTo(30)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.rightTime.text = ""
        self.rightcheck.text = ""
        self.rightTalkImageView.image = UIImage(named: "prepareImage")
    
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
