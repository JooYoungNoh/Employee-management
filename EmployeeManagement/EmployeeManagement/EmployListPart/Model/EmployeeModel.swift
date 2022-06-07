//
//  EmployeeModel.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/03.
//

import Foundation


class EmployeeModel {
    var name: String
    var phone: String
    var comment: String
    var profileImg: Bool
    
    init(name: String, phone: String, comment: String, profileImg: Bool){
        self.name = name
        self.phone = phone
        self.comment = comment
        self.profileImg = profileImg
    }
}
