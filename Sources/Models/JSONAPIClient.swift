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
    public let hostname: String
    public let port: Int?
    public let basePath: String?
    public let credentials: APICredentialStore?
    
    public let session = URLSession(configuration: .default)
    public let encoding: BodyEncoding
    public let useTLS: Bool

    // MARK: - Initialization
    public required init(hostname: String, port: Int?, basePath: String?, credentials: APICredentialStore?, useTLS: Bool) {
        self.hostname = hostname
        self.port = port
        self.basePath = basePath
        self.credentials = credentials
        self.encoding = .JSON
        self.useTLS = useTLS
    }
    
    // MARK: - Public Methods
    public func processSessionDataTask(data: Data?, response: URLResponse?, error: Error?) -> APIResult {
        fatalError()
//        let result: APIResult
//
//        guard error == nil else {
//            return APIResult.failure(error!)
//        }
//
//        if let data = data {
//            do {
//                guard let _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
//                    throw JSONAPIError.invalidData
//                }
//
//                result = APIResult.success(data)
//            } catch {
//                result = APIResult.failure(error)
//            }
//        } else {
//            result = APIResult.failure(error!)
//        }
//
//        return result
    }
    
}
