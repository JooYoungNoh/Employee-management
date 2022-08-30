//
//  ChattingRoomModel.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/31.
//

import Foundation

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
