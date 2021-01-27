//
//  LocationResult.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/23/21.
//

import Foundation

struct Location: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
