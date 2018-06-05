//
//  URL+URLRequest.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 11.03.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension URL {
    init(baseURL: String, path: String?, params: JSON?) {
        var components = URLComponents(string: "\(baseURL)\(path ?? "")")!
        
        if let params = params {
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: String(describing: value))
                components.queryItems?.append(queryItem)
            }
        }
        
        self = components.url!
    }
}

extension URLRequest {
    init(url: URL, method: HTTPMethod) {
        self.init(url: url)
        
        // set http method
        httpMethod = method.rawValue
    }
    
    init<T: Encodable>(url: URL, method: HTTPMethod, body: T) throws {
        self.init(url: url, method: method)
        
        switch method {
        case .post, .put:
            // set content type headers
            setValue("application/json", forHTTPHeaderField: "Content-Type")
            setValue("application/json", forHTTPHeaderField: "Accept")
            
            // set body content
            let encoder = JSONEncoder()
            
            encoder.dateEncodingStrategy = .formatted({
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                return formatter
                }())
            
            httpBody = try encoder.encode(body)
        default:
            break
        }
    }
}
