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


