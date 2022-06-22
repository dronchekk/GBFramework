//
//  RequestRouter.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 21.06.2022.
//

import Foundation
import Alamofire

enum RequestRouterEncoding {

    case url, json
}

protocol RequestRouter: URLRequestConvertible {

    var baseUrl: URL { set get }
    var httpMethod: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: RequestRouterEncoding { get }

    var id: String { get }
    var method: String { get }
    var token: String { set get }
    var login: String { set get }
    var password: String { set get }
    var time: String { get }

    var signature: String { get }
}

extension RequestRouter {

    var encoding: RequestRouterEncoding {
        //get { return .url }
        get { return .json }
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseUrl)
        urlRequest.httpMethod = httpMethod.rawValue

        switch self.encoding {
        case .url:
            return try URLEncoding.default.encode(urlRequest, with: parameters)

        case .json:
            return try JSONEncoding.default.encode(urlRequest, withJSONObject: parameters)
        }
    }

    func getTime() -> String {
        let now = Date()
        let ms = now.timeIntervalSince1970 * 1000 + TimeInterval(Int.random(in: 1...999) / 1000)
        return String(format: "%f", ms)
    }

    func getSignature() -> String {
        return "\(method)\(time)\(token)\(login.sha256)\(password.sha256)".sha256
    }
}
