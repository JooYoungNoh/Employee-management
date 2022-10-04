//
//  TransitionWriteCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/14.
//

import UIKit

class TransitionWriteCell: UICollectionViewCell {
    static let identifier = "TransitionWriteCell"
    
    var imageView: UIImageView = {
        let  img = UIImageView()
        img.layer.borderWidth = 0
        img.layer.masksToBounds = true
        return img
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(self.imageView)
        contentView.addSubview(self.checkImageView)
        
        imageView.contentMode = .scaleToFill
        imageView.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(180)
            make.center.equalToSuperview()
        }
        
        checkImageView.contentMode = .scaleToFill
        checkImageView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.trailing.equalTo(self.imageView.snp.trailing).offset(-5)
            make.bottom.equalTo(self.imageView.snp.bottom).offset(-5)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
