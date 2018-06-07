//
//  Service.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 06.03.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public protocol Service {
    associatedtype PrimaryResource: Decodable
    associatedtype Client: APIClient
    var client: Client { get }
    init(hostname: String, port: Int?, credentials: APICredentialStore?)
}

public extension Service {
    public init(config: APIConfiguration) {
        self.init(hostname: config.hostname, port: config.port, credentials: config.credentials)
    }
}
