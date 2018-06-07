//
//  APIClient.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 11.03.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public protocol APIClient {
    
    // MARK: - Properties
    var hostname: String { get }
    var port: Int? { get }
    var basePath: String? { get }
    var credentials: APICredentialStore? { get }
    
    var session: URLSession { get }
    var encoding: BodyEncoding { get }
    
    // MARK: - Initialization
    init(hostname: String, port: Int?, basePath: String?, credentials: APICredentialStore?)
    
    // MARK: - Methods
    func makeGETRequest(to path: String?, params: [String: Any]?, completion: @escaping (APIResult) -> Void)
    func makePOSTRequest<T: Encodable>(to path: String?, params: [String: Any]?, body: T, completion: @escaping (APIResult) -> Void) throws
    func makePUTRequest<T: Encodable>(to path: String?, params: [String: Any]?, body: T, completion: @escaping (APIResult) -> Void) throws
    func makeDELETERequest(to path: String?, params: [String: Any]?, completion: @escaping (APIResult) -> Void)
    
    func uploadMultipart(name: String, filename: String, data: Data, to path: String?, method: HTTPMethod, completion: @escaping (APIResult) -> Void) throws
    
    func executeSessionDataTask(request: URLRequest, completion: @escaping (APIResult) -> Void)
    func processSessionDataTask(data: Data?, response: URLResponse?, error: Error?) -> APIResult

}

public extension APIClient {
    
    // MARK: - Properties
    public var baseURL: String {
        return "http://\(hostname):\(port ?? 80)\(basePath != nil ? "/\(basePath!)" : "")"
    }
    
    // MARK: - Initialization
    public init(config: APIConfiguration, basePath: String?) {
        self.init(hostname: config.hostname, port: config.port, basePath: basePath, credentials: config.credentials)
    }
    
    // MARK: - Methods
    public func makeGETRequest(to path: String? = nil, params: [String: Any]? = nil, completion: @escaping (APIResult) -> Void) {
        let url = URL(baseURL: baseURL, path: path, params: params)
        let request = URLRequest(url: url, method: .get)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    public func makePOSTRequest<T: Encodable>(to path: String? = nil, params: [String: Any]? = nil, body: T, completion: @escaping (APIResult) -> Void) throws {
        let url = URL(baseURL: baseURL, path: path, params: nil)
        let request = try URLRequest(url: url, method: .post, body: body, encoding: encoding)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    public func makePUTRequest<T: Encodable>(to path: String? = nil, params: [String: Any]? = nil, body: T, completion: @escaping (APIResult) -> Void) throws {
        let url = URL(baseURL: baseURL, path: path, params: nil)
        let request = try URLRequest(url: url, method: .put, body: body, encoding: encoding)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    public func makeDELETERequest(to path: String? = nil, params: [String: Any]? = nil, completion: @escaping (APIResult) -> Void) {
        let url = URL(baseURL: baseURL, path: path, params: nil)
        let request = URLRequest(url: url, method: .delete)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    /// https://stackoverflow.com/questions/29623187/upload-image-with-multipart-form-data-ios-in-swift
    public func uploadMultipart(name: String, filename: String, data: Data, to path: String?, method: HTTPMethod, completion: @escaping (APIResult) -> Void) {
        let url = URL(baseURL: baseURL, path: path, params: nil)
        var request = URLRequest(url: url, method: method)
        
        func generateBoundary() -> String {
            return "Boundary-\(UUID().uuidString)"
        }
        
        func multipartPart(name: String, filename: String, data: Data, boundary: String) -> Data {
            var partData = Data()
            
            // 1 - Boundary should start with --
            let lineOne = "--" + boundary + "\r\n"
            partData.append(lineOne.data(using: .utf8, allowLossyConversion: false)!)
            
            // 2
            let lineTwo = "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n"
            partData.append(lineTwo.data(using: .utf8, allowLossyConversion: false)!)
            
            // 3
            let lineThree = "Content-Type: image/jpg\r\n\r\n"
            partData.append(lineThree.data(using: .utf8, allowLossyConversion: false)!)
            
            // 4
            partData.append(data)
            
            // 5
            let lineFive = "\r\n"
            partData.append(lineFive.data(using: .utf8, allowLossyConversion: false)!)
            
            // 6 - The end. Notice -- at the start and at the end
            let lineSix = "--" + boundary + "--\r\n"
            partData.append(lineSix.data(using: .utf8, allowLossyConversion: false)!)
            
            return partData
        }
        
        let boundary = generateBoundary()
        let formData = multipartPart(name: name, filename: filename, data: data, boundary: boundary)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(String(formData.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = formData
        request.httpShouldHandleCookies = false
        
        executeSessionDataTask(request: request) { result in
            completion(result)
        }
    }
    
    /// only support 'Bearer' authentication scheme (see RFC 6750)
    public func executeSessionDataTask(request: URLRequest, completion: @escaping (APIResult) -> Void) {
        var request = request
        
        // set bearer authorization header
        if let token = credentials?.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            let result = self.processSessionDataTask(data: data, response: response, error: error)
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }

}


