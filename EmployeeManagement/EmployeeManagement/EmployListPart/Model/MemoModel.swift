//
//  MemoModel.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/15.
//

import Foundation

struct MemoModel{
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
