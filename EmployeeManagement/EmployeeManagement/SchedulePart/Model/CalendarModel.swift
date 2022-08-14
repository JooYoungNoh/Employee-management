//
//  CalendarModel.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/14.
//

import Foundation

struct CalendarModel{
    
    var name: String
    var phone: String
    var startTime: String
    var endTime: String
    var nextday: Bool
    var allTime: String
    var work: String
    var userCheck: Bool
    var date: String
    var company: String
    
    init(name: String, phone: String, startTime: String, endTime: String, nextday: Bool, allTime: String, work: String, userCheck: Bool, date: String, company: String){
        self.name = name
        self.phone = phone
        self.startTime = startTime
        self.endTime = endTime
        self.nextday = nextday
        self.allTime = allTime
        self.work = work
        self.userCheck = userCheck
        self.date = date
        self.company = company
    }
}
