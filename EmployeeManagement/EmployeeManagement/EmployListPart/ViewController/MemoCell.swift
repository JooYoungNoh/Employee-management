//
//  MemoCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/15.
//

import UIKit
import SnapKit

class MemoCell: UITableViewCell {
    
    static let identifier = "MemoCell"
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.init(name: "CookieRun", size: 16)
        title.textColor = UIColor.black
        return title
    }()

    let dateLabel: UILabel = {
        let date = UILabel()
        date.font = UIFont.init(name: "CookieRun", size: 13)
        date.textColor = UIColor.systemGray
        date.numberOfLines = 2
        date.textAlignment = .center
        return date
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(8)
            make.width.equalTo(220)
            make.height.equalTo(40)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.top.equalTo(8)
            make.width.equalTo(100)
            make.height.equalTo(40)
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
