//
//  JSendAPIClient.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 02.03.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public enum JSendAPIError: Error {
    case invalidData
    case invalidJSON
    case custom(String?)
}

public struct JSendAPIClient: APIClient {
    
    // MARK: - Public Properties
    public let hostname: String
    public let port: Int?
    public let basePath: String?
    public let credentials: APICredentialStore?
    
    public let session = URLSession(configuration: .default)
    
    // MARK: - Private Properties
    private enum JSendResponse {
        case success(Data?)
        case fail(String?)
        case error(String?)
    }
    
    // MARK: - Initialization
    public init(hostname: String, port: Int?, basePath: String?, credentials: APICredentialStore?) {
        self.hostname = hostname
        self.port = port
        self.basePath = basePath
        self.credentials = credentials
    }
    
    // MARK: - Public Methods
    public func makeGETRequest(to path: String? = nil, params: JSON? = nil, completion: @escaping (APIResult) -> Void) {
        let url = URL(baseURL: baseURL, path: path, params: params)
        let request = URLRequest(url: url, method: .get)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    public func makePOSTRequest<T: Encodable>(to path: String? = nil, params: JSON? = nil, body: T, completion: @escaping (APIResult) -> Void) throws {
        let url = URL(baseURL: baseURL, path: path, params: nil)
        let request = try URLRequest(url: url, method: .post, body: body)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    public func makePUTRequest<T: Encodable>(to path: String? = nil, params: JSON? = nil, body: T, completion: @escaping (APIResult) -> Void) throws {
        let url = URL(baseURL: baseURL, path: path, params: nil)
        let request = try URLRequest(url: url, method: .put, body: body)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    public func makeDELETERequest(to path: String? = nil, params: JSON? = nil, completion: @escaping (APIResult) -> Void) {
        let url = URL(baseURL: baseURL, path: path, params: nil)
        let request = URLRequest(url: url, method: .delete)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    // MARK: - Private Methods
    public func processSessionDataTask(data: Data?, response: URLResponse?, error: Error?) -> APIResult {
        let result: APIResult
        
        if let data = data {
            do {
                result = try self.getResult(for: try self.getResponse(for: data))
            } catch {
                result = APIResult.failure(error)
            }
        } else {
            result = APIResult.failure(error!)
        }
        
        return result
    }
    
    private func getResponse(for data: Data) throws -> JSendResponse {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
            throw JSendAPIError.invalidData
        }
        
        guard let status = json["status"] as? String else {
            throw JSendAPIError.invalidJSON
        }
        
        switch status {
        case "success":
            guard let json = json["data"] else {
                throw JSendAPIError.invalidJSON
            }
            
            if let _ = json as? NSNull {
                return JSendResponse.success(nil)
            } else {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                return JSendResponse.success(jsonData)
            }
        case "fail":
            return JSendResponse.fail(json["data"] as? String)
        case "error":
            return JSendResponse.error(json["message"] as? String)
        default:
            throw JSendAPIError.invalidJSON
        }
    }
    
    private func getResult(for response: JSendResponse) throws -> APIResult {
        switch response {
        case .error(let message), .fail(let message):
            return APIResult.failure(JSendAPIError.custom(message))
        case .success(let data):
            return APIResult.success(data)
        }
    }
    
}
