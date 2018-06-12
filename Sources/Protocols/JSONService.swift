//
//  JSONService.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 11.06.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public protocol JSONService: Service where Client: JSONAPIClient { }

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
    
    public func getError(from result: APIResult) -> Error? {
        switch result {
        case .success(_):
            return nil
        case .failure(let error):
            return error
        }
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) -> (instance: T?, error: Error?) {
        do {
            let decoder = JSONDecoder()
            
            decoder.dateDecodingStrategy = .formatted({
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                return formatter
            }())
            
            let instance = try decoder.decode(type, from: data)
            
            return (instance, nil)
        } catch {
            return (nil, error)
        }
    }
    
    public func decode<T: Decodable>(_ type: T.Type, from result: APIResult, at key: String? = nil) -> (instance: T?, error: Error?) {
        switch result {
        case .success(let data):
            guard let data = data else {
                return (nil, nil)
            }
            
            guard let key = key else {
                return decode(type, from: data)
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    throw JSONAPIError.invalidData
                }
                
                guard let jsonOfInterest = json[key] else {
                    throw JSONAPIError.invalidJSON
                }
                
                guard JSONSerialization.isValidJSONObject(jsonOfInterest) else {
                    // result is top-level value
                    if let instance = json[key] as? T {
                        return (instance, nil)
                    } else {
                        return (nil, JSONAPIError.invalidJSON)
                    }
                }
                
                let jsonData = try JSONSerialization.data(withJSONObject: jsonOfInterest, options: [])
                
                let result = decode(type, from: jsonData)
                return (result.instance, result.error)
            } catch {
                return (nil, error)
            }
        case .failure(let error):
            return (nil, error)
        }
    }
    
}
