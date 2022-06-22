//
//  AuthSignInResult.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

struct AuthSignInResult: Codable {

    struct Result: Codable {

        let code: Int
        let message: String
        let token: String
    }

    let jsonrpc: String
    let result: Result?
    let error: ApiResultError?
}
