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
}
