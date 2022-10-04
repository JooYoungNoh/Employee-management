//
//  CreateChatCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/21.
//

import UIKit

class CreateChatCell: UITableViewCell {

    static let identifier = "CreateChatCell"
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CookieRun", size: 15)
        label.textColor = UIColor.black
        return label
    }()
    
    var checkImageView: UIImageView = {
        let  img = UIImageView()
        img.layer.borderWidth = 0
        img.layer.cornerRadius = 20
        img.layer.masksToBounds = true
        img.tintColor = .systemBlue
        img.backgroundColor = .white
        img.isHidden = true
        img.image = UIImage(systemName: "checkmark.circle.fill")
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkImageView)
        
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.width.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(20)
            make.leading.equalTo(self.userImageView.snp.trailing).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
        
        checkImageView.contentMode = .scaleToFill
        checkImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-15)
            make.top.equalTo(self.snp.top).offset(20)
            make.width.height.equalTo(30)
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
