//
//  NoticeListCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/07.
//

import UIKit

class NoticeListCell: UITableViewCell {

    static let identifier = "NoticeListCell"
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.init(name: "CookieRun", size: 16)
        title.textColor = UIColor.black
        return title
    }()

    var dateLabel: UILabel = {
        let date = UILabel()
        date.font = UIFont.init(name: "CookieRun", size: 13)
        date.textColor = UIColor.systemGray
        date.numberOfLines = 2
        date.textAlignment = .center
        return date
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-25)
            make.top.equalTo(8)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.dateLabel.snp.leading).offset(-10)
            make.top.equalTo(8)
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
