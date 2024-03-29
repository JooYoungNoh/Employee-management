//
//  CreateChatModel.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/21.
//

import Foundation
import UIKit

struct CreateChatModel: Hashable {
    
    var name: String
    var phone: String
    var comment: String
    var id: String
    var profileImg: Bool
    
    init(name: String, phone: String, comment: String, id: String, profileImg: Bool){
        self.name = name
        self.phone = phone
        self.comment = comment
        self.id = id
        self.profileImg = profileImg
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(self.phone.hashValue)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.hashValue == rhs.hashValue
    }
}

struct collectionListModel {
    var name: String
    var phone: String
    var image: UIImage
    
    init(name: String, phone: String, image: UIImage){
        self.name = name
        self.phone = phone
        self.image = image
    }
}
