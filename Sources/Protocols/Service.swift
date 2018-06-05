//
//  Service.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 06.03.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

protocol Service {
    associatedtype PrimaryResource: Decodable
    associatedtype Client: APIClient
    var client: Client { get }
    init(hostname: String, port: Int, credentials: APICredentialStore?)
    init(config: APIConfiguration)
}

extension Service {
    init(config: APIConfiguration) {
        self.init(hostname: config.hostname, port: config.port ?? 80, credentials: config.credentials)
    }
}
