//
//  JSONService.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 11.06.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public protocol JSONService: Service where Client == JSONAPIClient { }

public extension JSONService {
    public func getJSON(from result: APIResult) -> (json: [AnyHashable: Any]?, error: Error?) {
        switch result {
        case .success(let data):
            guard let data = data else {
                return (nil, nil)
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard let jsonDictionary = jsonObject as? [AnyHashable: Any] else {
                    return (nil, JSONAPIError.invalidJSON)
                }
                
                return (jsonDictionary, nil)
            } catch {
                return (nil, error)
            }
        case .failure(let error):
            return (nil, error)
        }
    }
}
