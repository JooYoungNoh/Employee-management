//
//  CalendarCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/04.
//

import UIKit

class CalendarCell: UITableViewCell {

    static let identifier = "CalendarCell"
    
    var checkView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.init(name: "CookieRun", size: 13)
        title.textColor = UIColor.black
        return title
    }()

    var dateLabel: UILabel = {
        let date = UILabel()
        date.font = UIFont.init(name: "CookieRun", size: 13)
        date.textColor = UIColor.systemGray
        date.numberOfLines = 1
        date.textAlignment = .center
        return date
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(checkView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        checkView.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(28)
            make.width.height.equalTo(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.checkView.snp.trailing).offset(5)
            make.top.equalTo(10)
            make.width.equalTo(220)
            make.height.equalTo(40)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.top.equalTo(10)
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
