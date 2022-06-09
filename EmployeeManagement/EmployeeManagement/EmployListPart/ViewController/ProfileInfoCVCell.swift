//
//  ProfileInfoCVCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/10.
//

import UIKit
import SnapKit

class ProfileInfoCVCell: UICollectionViewCell {
    
    static let identifier = "ProfileInfoCVCell"
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "CookieRun", size: 15)
        title.textColor = UIColor.black
        title.textAlignment = .center
        title.backgroundColor = .systemGray6
        return title
    }()
    
    var imageView: UIImageView = {
        let  img = UIImageView()
        img.image = UIImage(named: "logonil")
       // img.layer.cornerRadius = 25
        img.layer.borderWidth = 0
        img.layer.masksToBounds = true
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray6
        contentView.addSubview(self.titleLabel)
        contentView.addSubview(self.imageView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(30)
        }
        
        imageView.contentMode = .scaleToFill
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.titleLabel.snp.centerX)
            make.bottom.equalTo(self.titleLabel.snp.top).offset(-6)
            make.width.equalTo(84)
            make.height.equalTo(84)
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
