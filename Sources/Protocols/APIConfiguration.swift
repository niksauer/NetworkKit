//
//  APIConfiguration.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 07.06.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public protocol APIConfiguration {
    var hostname: String { get }
    var port: Int? { get }
    var credentials: APICredentialStore? { get }
}
