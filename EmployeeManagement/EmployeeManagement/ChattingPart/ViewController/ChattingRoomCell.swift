//
//  ChattingRoomCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/30.
//

import UIKit

class ChattingRoomCell: UITableViewCell {
    //내가 한 대화
    let rightTalkBox: UILabel = {
        let label = UILabel()
        
        return label
    }()
    let rightTime: UILabel = {
        let label = UILabel()
        
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
    let nameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    let leftTalkBox: UILabel = {
        let label = UILabel()
        
        return label
    }()
    let leftTime: UILabel = {
        let label = UILabel()
        
        return label
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
