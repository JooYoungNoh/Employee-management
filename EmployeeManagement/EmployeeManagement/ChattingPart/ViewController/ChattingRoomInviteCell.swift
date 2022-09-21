//
//  ChattingRoomInviteCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/09/21.
//

import UIKit

class ChattingRoomInviteCell: UITableViewCell {

    //내가 대화할 때
    static let identifier = "ChattingRoomInviteCell"
    
    let inviteLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textColor = .blue
        label.textAlignment = .center
        label.font = UIFont(name: "CookieRun", size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray6
        contentView.addSubview(self.inviteLabel)
        inviteLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.leading.trailing.equalToSuperview()
        }
      
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.inviteLabel.text = ""
    
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
