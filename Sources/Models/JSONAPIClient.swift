//
//  JSONAPIClient.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 07.06.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public class JSONAPIClient: APIClient {
    
    // MARK: - Public Properties
    public let hostURL: String
    public let port: Int?
    public let basePath: String?
    public let credentials: APICredentialStore?
    
    public let session = URLSession(configuration: .default)
    public let encoding: BodyEncoding
    
    // MARK: - Initialization
    public required init(hostURL: String, port: Int?, basePath: String?, credentials: APICredentialStore?) {
        self.hostURL = hostURL
        self.port = port
        self.basePath = basePath
        self.credentials = credentials
        self.encoding = .JSON
    }
    
    // MARK: - Public Methods
    public func processSessionDataTask(data: Data?, response: URLResponse?, error: Error?) -> APIResult {
        guard error == nil else {
            return APIResult.failure(error!)
        }
        
        let result: APIResult

        if let data = data {
            do {
                guard let _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    throw JSONAPIError.invalidData
                }
                
                result = APIResult.success(data)
            } catch {
                result = APIResult.failure(error)
            }
        } else {
            result = APIResult.failure(error!)
        }

        return result
    }
    
}
