//
//  JSendAPIClient.swift
//  NetworkKit
//
//  Created by Niklas Sauer on 02.03.18.
//  Copyright © 2018 SauerStudios. All rights reserved.
//

import Foundation

public class JSendAPIClient: JSONAPIClient {

    // MARK: - Private Types
    private enum JSendResponse {
        case success(Data?)
        case fail(String?)
        case error(String?)
    }

    // MARK: - Public Methodd
    public override func processSessionDataTask(data: Data?, response: URLResponse?, error: Error?) -> APIResult {
        let result: APIResult

        if let data = data {
            do {
                result = try self.getResult(for: try self.getResponse(for: data))
            } catch {
                result = APIResult.failure(error)
            }
        } else {
            result = APIResult.failure(error!)
        }

        return result
    }

    // MARK: - Private Methods
    private func getResponse(for data: Data) throws -> JSendResponse {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw JSONAPIError.invalidData
        }

        guard let status = json["status"] as? String else {
            throw JSONAPIError.invalidJSON
        }

        switch status {
        case "success":
            guard let json = json["data"] else {
                throw JSONAPIError.invalidJSON
            }

            if let _ = json as? NSNull {
                return JSendResponse.success(nil)
            } else {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                return JSendResponse.success(jsonData)
            }
        case "fail":
            return JSendResponse.fail(json["data"] as? String)
        case "error":
            return JSendResponse.error(json["message"] as? String)
        default:
            throw JSONAPIError.invalidJSON
        }
    }

    private func getResult(for response: JSendResponse) throws -> APIResult {
        switch response {
        case .error(let message), .fail(let message):
            return APIResult.failure(JSONAPIError.custom(message))
        case .success(let data):
            return APIResult.success(data)
        }
    }

}
