//
//  APICredentialStore.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 07.06.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public protocol APICredentialStore {
    func getUserID() -> Int?
    func setUserID(_ userID: Int?) throws
    func getToken() -> String?
    func setToken(_ token: String?) throws
    func reset() throws
}
