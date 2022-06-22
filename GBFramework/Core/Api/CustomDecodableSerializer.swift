//
//  CustomDecodableSerializer.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 21.06.2022.
//

import Foundation
import Alamofire

class CustomDecodableSerializer<T: Decodable>: DataResponseSerializerProtocol {
    
    private let errorParser: AbstractErrorParser
    
    init(errorParser: AbstractErrorParser) {
        self.errorParser = errorParser
    }
    
    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
        if let error = errorParser.parse(response: response, data: data, error: error) {
            throw error
        }
        do {
            let data = try DataResponseSerializer().serialize(request: request, response: response, data: data, error: error)
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        }
        catch {
            //let _ = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
            let customError = errorParser.parse(error)
            throw customError
        }
    }
}
