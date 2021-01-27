//
//  NetworkResponse.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/23/21.
//

import Foundation

struct NetworkResponse: Codable {
    let status: Int
    let error: String
}

extension NetworkResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
