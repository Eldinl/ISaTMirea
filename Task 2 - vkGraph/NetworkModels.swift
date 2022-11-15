//
//  NetworkModels.swift
//  IS&T
//
//  Created by Леонид on 01.11.2022.
//

import Foundation

struct ApiResult<DataType: Decodable>: Decodable {
    var response: DataType?
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            response = try values.decode(DataType.self, forKey: .data)
        } catch {
            let result = try? values.decode(String.self, forKey: .data)
            if let result = result, result.isEmpty {
                response = nil
            }
            else {
                fatalError("\(error)")
            }
        }
        
    }
}

struct ErrorModel: Error {
    var message: String
    var code: Int?
    var errorStatus: ErrorStatus
    
    enum ErrorStatus {
        case NO_CONNECTION
        case BAD_RESPONSE
        case DECODING_RESPONSE_ERROR
        case TIMEOUT
        case EMPTY_RESPONSE
        case NOT_DEFINED
        case UNAUTHORIZED
        case SERVER_ERROR
        case INVALID_URL
        case REQUEST_TO_LARGE
        case CUSTOM
    }
}
