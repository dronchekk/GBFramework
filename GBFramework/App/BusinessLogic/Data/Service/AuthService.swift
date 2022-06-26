//
//  AuthService.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

protocol AuthService {

    var isAuthed: Bool { get }

    func signIn(withCredentials: AuthCredentials, completion: @escaping (Bool, String?) -> Void)
    func signOut(completion: @escaping BoolClosure)
}

class AuthServiceImpl: AuthService {

    // TODO: почему с LET не работает??
    private var authRepository: AuthRepository
    private let requestFactory = RequestFactory()

    var isAuthed: Bool { !authRepository.data.token.isEmpty }

    init(authrepository: AuthRepository) {
        self.authRepository = authrepository
    }

    // MARK: - Sign In
    func signIn(withCredentials credentials: AuthCredentials, completion: @escaping (Bool, String?) -> Void) {
        let auth = requestFactory.makeAuthRequestFactory()
        auth.signIn(login: credentials.login, password: credentials.password) { response in
            ActivityHelper.shared.remove(response.request?.httpBody)
            var errorMessage: String?
            switch response.result {
            case .success(let responseData):
                if let success = responseData.result {
                    var credentials = credentials
                    credentials.token = success.token
                    self.authRepository.data = credentials
                }
                else if let error = responseData.error {
                    errorMessage = error.message
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            completion(self.isAuthed, errorMessage)
        }
    }

    // MARK: - SignOut
    func signOut(completion: @escaping BoolClosure) {
        self.authRepository.data = AuthCredentials()
        completion(isAuthed)
    }
}
