//
//  ChattingImageListCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/09/19.
//

import UIKit
import SnapKit

class ChattingImageListCell: UICollectionViewCell {
    static let identifier = "ChattingImageListCell"
    
    var imageView: UIImageView = {
        let  img = UIImageView()
        img.layer.borderWidth = 0
        img.layer.masksToBounds = true
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(self.imageView)
    
        imageView.contentMode = .scaleToFill
        imageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
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
