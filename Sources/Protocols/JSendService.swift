//
//  JSendService.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 06.03.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public protocol JSendService: JSONService where Client == JSendAPIClient {
    associatedtype PrimaryResource: Decodable
}

public extension JSendService {
    
    public func decodeResource(from result: APIResult) -> (instance: PrimaryResource?, error: Error?) {
        return decode(PrimaryResource.self, from: result)
    }
    
}
