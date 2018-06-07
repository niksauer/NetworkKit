//
//  URLRequest.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 07.06.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public extension URLRequest {
    public init(url: URL, method: HTTPMethod) {
        self.init(url: url)
        
        // set http method
        httpMethod = method.rawValue
    }
    
    public init<T: Encodable>(url: URL, method: HTTPMethod, body: T, encoding: BodyEncoding) throws {
        self.init(url: url, method: method)
        
        switch method {
        case .post, .put:
            switch encoding {
            case .JSON:
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
                fatalError("This encoding method has not been implemented")
            }
        default:
            break
        }
    }
}
