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
        label.font = UIFont(name: "CookieRun", size: 15)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    let timeCheckView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(self.cellNameLabel)
        contentView.addSubview(self.timeCheckView)
        
        cellNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        
        /*if self.timeInDB == "12:00" {
            
        } else {
            
        }*/
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
