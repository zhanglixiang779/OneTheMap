//
//  User.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/24/21.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
