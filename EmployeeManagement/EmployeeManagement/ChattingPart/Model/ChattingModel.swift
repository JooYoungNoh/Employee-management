//
//  ChattingModel.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/18.
//

import Foundation
import UIKit

struct ChattingModel {
    var activation: Bool
    var date: TimeInterval
    var memberCount: String
    var newCount: String
    var newMessage: String
    var roomTitle: String
    var phoneList: [String]
    var presentUser: [String]
    var type: String
    var dbID: String
    
    init(activation: Bool, date: TimeInterval, memberCount: String, newCount: String, newMessage: String, roomTitle: String, phoneList: [String], presentUser: [String], type: String, dbID: String){
        self.activation = activation
        self.date = date
        self.memberCount = memberCount
        self.newCount = newCount
        self.newMessage = newMessage
        self.roomTitle = roomTitle
        self.phoneList = phoneList
        self.presentUser = presentUser
        self.type = type
        self.dbID = dbID
    }
}

struct imageSave {
    var userPhone: String
    var userImage: UIImage
    
    init(userPhone: String, userImage: UIImage) {
        self.userPhone = userPhone
        self.userImage = userImage
    }
}
