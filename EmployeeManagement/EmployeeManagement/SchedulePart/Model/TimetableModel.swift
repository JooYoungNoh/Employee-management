//
//  TimetableModel.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/09.
//

import Foundation

struct TimetableModel{
    
    var name: String
    var phone: String
    var startTime: String
    var endTime: String
    var nextday: String
    var allTime: String
    var work: String
    var userCheck: String
    var date: String
    
    init(name: String, phone: String, startTime: String, endTime: String, nextday: String, allTime: String, work: String, userCheck: String, date: String){
        self.name = name
        self.phone = phone
        self.startTime = startTime
        self.endTime = endTime
        self.nextday = nextday
        self.allTime = allTime
        self.work = work
        self.userCheck = userCheck
        self.date = date
    }
}
