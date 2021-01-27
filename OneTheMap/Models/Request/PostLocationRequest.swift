//
//  PostLocationRequest.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/24/21.
//

import Foundation

struct PostLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
}
