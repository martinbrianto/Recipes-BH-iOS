//
//  SignInViewModel.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import Foundation
import RxSwift

protocol SignInViewModel {
    init(repository: SignInRepository, formModelValidator: FormModelValidator)
    
    var rxSignInResult: Observable<Result<Void, Error>> { get }
    
    func processUserSignIn(email: String, password: String)
}

final class SignInViewModelImpl: SignInViewModel {
    
    // MARK: - Variable
    
    private let repository: SignInRepository
    private let formModelValidator: FormModelValidator
    
    // MARK: - Inits
    
    init(repository: SignInRepository = SignInRepositoryImpl(), formModelValidator: FormModelValidator = FormModelValidatorImpl()) {
        self.repository = repository
        self.formModelValidator = formModelValidator
    }
    
    // MARK: - Outputs
    
    private let _rxSignInResult = PublishSubject<Result<Void, Error>>()
    var rxSignInResult: Observable<Result<Void, Error>> { _rxSignInResult }
    
    // MARK: - Inputs
    
    func processUserSignIn(email: String, password: String) {
        
        if !formModelValidator.isEmailValid(email: email) {
            _rxSignInResult.onNext(.failure(FormError.emailNotValid))
            return
        }
        
        if !formModelValidator.isPasswordValid(password: password){
            _rxSignInResult.onNext(.failure(FormError.passwordNotValid))
            return
        }
        
        if repository.isPasswordValid(forEmail: email, password: password) {
            repository.saveLoggedInUserCredentials(forEmail: email)
            _rxSignInResult.onNext(.success(()))
        } else {
            _rxSignInResult.onNext(.failure(SignInError.passwordDoNotMatch))
        }
    }
}
