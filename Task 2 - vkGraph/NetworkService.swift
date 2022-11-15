//
//  NetworkService.swift
//  IS&T
//
//  Created by Леонид on 01.11.2022.
//

import Foundation
import Alamofire

class NetworkService {
    let baseUrl: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(baseURL: String) {
        baseUrl = baseURL
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    func jsonRequest<RequestDataType, ResponseDataType>(_ url: String,
                                                        method: HTTPMethod = .get,
                                                        parameters: RequestDataType? = nil,
                                                        responseType: ResponseDataType.Type)
    async throws -> ResponseDataType
    where RequestDataType: Encodable, ResponseDataType: Decodable {

        var headers: HTTPHeaders = []
        
        if let token = UserDefaults.standard.string(forKey: "Token") {
            headers.add(.authorization(bearerToken: token))
        }
        
        let request = AF.request(baseUrl + url, method: method, parameters: parameters,
                                 encoder: .json(encoder: encoder), headers: headers)
        
        return try await sendRequest(request: request, responseType: responseType)
    }
    
    private func sendRequest<ResponseDataType: Decodable>(request: DataRequest,
                                                          responseType: ResponseDataType.Type) async throws -> ResponseDataType {
        let response = await request
            .validate()
            .serializingDecodable(ApiResult<ResponseDataType>.self, decoder: decoder)
            .response
        
        switch response.result {
        case .success(let value):
            guard let data = value.response else {
                throw ErrorModel(message: "Response Data is empty", errorStatus: .EMPTY_RESPONSE)
            }
            
            return data
            
        case .failure(let error):
            guard error.isResponseSerializationError else {
                throw error
            }
            
            let response = await request
                .validate()
                .serializingDecodable(ResponseDataType.self, decoder: decoder)
                .response
            
            switch response.result {
            case .success(let value):
                return value
            case .failure(let error):
                throw error
            }
        }
    }
    
    private func buildError(error: AFError) -> ErrorModel {
        if let urlError = error.underlyingError as? URLError {
            if urlError.code == .notConnectedToInternet {
                return ErrorModel(message: "No connection to internet", errorStatus: .NO_CONNECTION)
            } else if urlError.code == .timedOut {
                return ErrorModel(message: "Connection time out", errorStatus: .TIMEOUT)
            }
        }
        
        guard error.isResponseSerializationError == false else {
            return ErrorModel(message: "Decoding response error", errorStatus: .DECODING_RESPONSE_ERROR)
        }
        
        guard let code = error.responseCode else {
            return ErrorModel(message: "Not defined error", errorStatus: .NOT_DEFINED)
        }
        switch code {
        case 204 ... 205:
            return ErrorModel(message: "Response Data is empty", errorStatus: .EMPTY_RESPONSE)
        case 500 ..< 600:
            return ErrorModel(message: "Server error", code: code, errorStatus: .SERVER_ERROR)
        case 401:
            return ErrorModel(message: "Unauthorized", code: code, errorStatus: .UNAUTHORIZED)
        case 413:
            return ErrorModel(message: "Request is to large", code: code, errorStatus: .REQUEST_TO_LARGE)
        default:
            return ErrorModel(message: "Not defined error", code: code, errorStatus: .NOT_DEFINED)
        }
    }
}
