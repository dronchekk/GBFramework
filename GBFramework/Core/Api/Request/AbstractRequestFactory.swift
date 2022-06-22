//
//  AbstractRequestFactory.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 21.06.2022.
//

import Foundation
import Alamofire

protocol AbstractRequestFactory {

    var errorParser: AbstractErrorParser { get }
    var sessionManager: Session { get }
    var queue: DispatchQueue { get }

    @discardableResult
    func request<T: Decodable>(request: URLRequestConvertible,
                               completionHandler: @escaping (AFDataResponse<T>) -> Void) -> DataRequest
}

extension AbstractRequestFactory {

    @discardableResult
    func request<T: Decodable>(request: URLRequestConvertible,
                               completionHandler: @escaping (AFDataResponse<T>) -> Void) -> DataRequest {
        return sessionManager.request(request).responseCodable(errorParser: errorParser, completionHandler: completionHandler)
    }
}
