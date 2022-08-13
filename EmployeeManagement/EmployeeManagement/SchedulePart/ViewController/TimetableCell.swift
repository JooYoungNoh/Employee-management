//
//  TimetableCell.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/09.
//

import UIKit
import SnapKit

class TimetableCell: UICollectionViewCell {
    static let identifier = "TimetableCell"
    
    var cellNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CookieRun", size: 13)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 3
        label.layer.borderColor = UIColor.systemGray.cgColor
        return label
    }()
    
    let timeCheckView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray.cgColor
        
        contentView.addSubview(self.cellNameLabel)
        contentView.addSubview(self.timeCheckView)
        
        cellNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
