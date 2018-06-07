//
//  JSONAPIError.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 07.06.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public enum JSONAPIError: Error {
    case invalidData
    case invalidJSON
    case custom(String?)
}
