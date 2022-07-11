//
//  SelectModel.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/11.
//

import Foundation

struct SelectModel{
    var text: String
    var date: TimeInterval
    var count: String
    var title: String
    
    init(text: String, date: TimeInterval, count: String, title: String){
        self.text = text
        self.date = date
        self.count = count
        self.title = title
    }
}
