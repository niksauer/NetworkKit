//
//  APIResult.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 07.06.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public enum APIResult {
    case success(Data?)
    case failure(Error)
}
