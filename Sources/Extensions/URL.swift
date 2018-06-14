//
//  URL.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 11.03.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public extension URL {
    public init(baseURL: String, path: String?, params: [String: Any]?) {
        var newBaseURL = baseURL
        var newPath = path
        
        if baseURL.last == "/" {
            newBaseURL = String(baseURL.dropLast())
        }
    
        if let path = path, path.starts(with: "/") {
            newPath = String(path.dropFirst())
        }
        
        var components: URLComponents
        
        if let path = newPath {
            components = URLComponents(string: "\(newBaseURL)/\(path)")!
        } else {
            components = URLComponents(string: "\(newBaseURL)")!
        }
    
        if let params = params {
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: String(describing: value))
                components.queryItems?.append(queryItem)
            }
        }
    
        self = components.url!
    }
}


