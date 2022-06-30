//
//  LoginVC.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    
    // MARK: - Coordinator
    var onSignIn: VoidClosure?
    var onRegister: VoidClosure?
    
    // MARK: - Properties
    var loginProvider: LoginProvider?
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    private let isSignInEnabled = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Outlets
    @IBOutlet weak var loginTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addBindings()
    }
    
    // MARK: - Private
    private func configure() {
        loginTextfield.style = Styles.shared.tf.dfPr
        passwordTextfield.style = Styles.shared.tf.dfPr
        signInButton.style = Styles.shared.button.bevelDfPr
        signUpButton.style = Styles.shared.button.quietDfPr
    }
    
    private func addBindings() {
        
        Observable
            .combineLatest(
                loginTextfield.rx.text.orEmpty,
                passwordTextfield.rx.text.orEmpty
            )
            .map { login, password -> Bool in
                login.isValidLogin && password.isValidPassword
            }
            .bind(to: isSignInEnabled)
            .disposed(by: disposeBag)
        
        isSignInEnabled
            .do { [weak self] isEnabled in
                self?.signInButton.isEnabled = isEnabled
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    // MARK: - Data
    func updateData() {
        loginTextfield.setPlaceholder(Locales.value("vc_login_prompt_login"), with: Styles.shared.tf.dfPh)
        passwordTextfield.setPlaceholder(Locales.value("vc_login_prompt_password"), with: Styles.shared.tf.dfPh)
        signInButton.setTitle(Locales.value("vc_login_button_signIn"), for: .normal)
        signUpButton.setTitle(Locales.value("vc_login_button_signUp"), for: .normal)
    }
    
    // MARK: - Taps
    @IBAction func onTapSignIn(_ sender: UIButton) {
        guard let login = loginTextfield.text, let password = passwordTextfield.text else { return }
        if login.isEmpty {
            loginTextfield.showTfError()
            self.showToast(message: Locales.value("toast_login_error"))
            return
        }
        if password.isEmpty {
            passwordTextfield.showTfError()
            self.showToast(message: Locales.value("toast_password_error"))
            return
        }
        loginProvider?.signIn(with: AuthCredentials(login: login, password: password)) { [weak self] isAuthed, errorMessage in
            if !isAuthed, let errorMessage = errorMessage {
                self?.showToast(message: errorMessage)
            }
            else {
                self?.onSignIn?()
            }
        }
    }
    
    @IBAction func onTapSignUp(_ sender: UIButton) {
        onRegister?()
    }
    
    // MARK: - Textfield
    @IBAction func onEditingDidEnd(_ sender: UITextField) {
        sender.showTfUp()
    }
    
    @IBAction func onEditingDidBegin(_ sender: UITextField) {
        sender.showTfFocused()
    }
}
