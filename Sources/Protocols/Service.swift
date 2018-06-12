//
//  Service.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 06.03.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public protocol Service {
    associatedtype Client: APIClient
    var client: Client { get }
    init(hostURL: String, port: Int?, credentials: APICredentialStore?)
}

public extension Service {
    public init(config: APIConfiguration) {
        self.init(hostURL: config.hostURL, port: config.port, credentials: config.credentials)
    }
    
    public func getError(from result: APIResult) -> Error? {
        switch result {
        case .success(_):
            return nil
        case .failure(let error):
            return error
        }
    }
    
    public func getData(from result: APIResult) -> (instance: Data?, error: Error?) {
        switch result {
        case .success(let data):
            guard let data = data else {
                return (nil, nil)
            }
            
            return (data, nil)
        case .failure(let error):
            return (nil, error)
        }
    }
}
