//
//  ChattingRoomModel.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/31.
//

import Foundation
import UIKit

struct ChattingRoomModel {
    var checkRead: Bool
    var imgCheck: Bool
    var date: TimeInterval
    var sender: String
    var message: String
    var readList: [String]
    
    init(checkRead: Bool, imgCheck: Bool, date: TimeInterval, sender: String, message: String, readList: [String]){
        self.checkRead = checkRead
        self.imgCheck = imgCheck
        self.date = date
        self.sender = sender
        self.message = message
        self.readList = readList
    }
}

struct roomImageSave {
    var userPhone: String
    var userImage: UIImage
    
    init(userPhone: String, userImage: UIImage) {
        self.userPhone = userPhone
        self.userImage = userImage
    }
}

struct chatImageSave {
    var title: String
    var image: UIImage
    var date: TimeInterval
    
    init(title: String, image: UIImage, date: TimeInterval) {
        self.title = title
        self.image = image
        self.date = date
    }
}

//커스텀 레이블(패딩)
class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 14.0, left: 10.0, bottom: 14.0, right: 10.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
