//
//  NetworkClient.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/23/21.
//

import Foundation

struct NetworkClient {
    
    static var sessionId = ""
    static var uniqueKey = ""
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case logout
        case getUserInfo(String)
        case getLocations(Int)
        case postLocation
        
        var stringValue: String {
            switch self {
            case .login, .logout:
                return "\(Endpoints.base)/session"
            case .getUserInfo(let uniqueKey):
                return "\(Endpoints.base)/users/\(uniqueKey)"
            case .getLocations(let number):
                return "\(Endpoints.base)/StudentLocation?limit=\(number)&order=-updatedAt"
            case .postLocation:
                return "\(Endpoints.base)/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    private static func getRealData(_ data: Data) -> Data {
        data.subdata(in: 5 ..< data.count)
    }
    
    // MARK: Generic get request api call
    
    private static func getRequest<Response: Decodable>(
        isDataSecured: Bool,
        url: URL,
        type: Response.Type,
        completion: @escaping (Response?, Error?) -> Void
    ) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
          
            do {
                let response = try JSONDecoder().decode(type, from: isDataSecured ? getRealData(data) : data)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                do {
                    let errorResponse = try JSONDecoder().decode(NetworkResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    // MARK: Generic post request api call

    private static func postRequest<Request: Encodable, Response: Decodable>(
        isDataSecured: Bool,
        url: URL,
        body: Request,
        type: Response.Type,
        completion: @escaping (Response?, Error?) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let response = try JSONDecoder().decode(type, from: isDataSecured ? getRealData(data) : data)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                do {
                    let errorResponse = try JSONDecoder().decode(NetworkResponse.self, from: isDataSecured ? getRealData(data) : data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    static func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: ["username": email, "password":password])
        postRequest(isDataSecured: true, url: Endpoints.login.url, body: body, type: LoginResponse.self) { (response, error) in
            if let response = response {
                sessionId = response.session.id
                uniqueKey = response.account.key
                completion(response.account.registered, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    static func postLocation(
        firstName: String,
        lastName: String,
        mapString: String,
        mediaURL: String,
        latitude: Double,
        longitude: Double,
        completion: @escaping (Bool, Error?) -> Void) {
        let body = PostLocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        postRequest(isDataSecured: false, url: Endpoints.postLocation.url, body: body, type: PostLocationResponse.self) { (response, error) in
            if let _ = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    static func getLocations(number: Int, completion: @escaping ([Location], Error?) -> Void) {
        getRequest(isDataSecured: false, url: Endpoints.getLocations(number).url, type: LocationResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    static func getUserInfo(completion: @escaping (User?, Error?) -> Void) {
        getRequest(isDataSecured: true, url: Endpoints.getUserInfo(uniqueKey).url, type: User.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            sessionId = ""
            DispatchQueue.main.async {
                completion()
            }
        }
        task.resume()
    }
 }
