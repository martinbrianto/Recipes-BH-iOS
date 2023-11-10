//
//  SignUpViewModel.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import Foundation
import RxSwift

protocol SignUpViewModel {
    init(formModelValidator: FormModelValidator, repository: SignUpRepository)
    
    var rxSignUpResult: Observable<Result<Void,Error>> { get }
    
    func processUserSignUp(email: String, name: String, password: String, repeatPassword: String)
}

final class SignUpViewModelImpl: SignUpViewModel {
    
    // MARK: - Variable
    
    private let formModelValidator: FormModelValidator
    private let repository: SignUpRepository
    
    
    // MARK: - Init
    init(formModelValidator: FormModelValidator = FormModelValidatorImpl(), repository: SignUpRepository = SignUpRepositoryImpl()) {
        self.formModelValidator = formModelValidator
        self.repository = repository
    }
    
    // MARK: - Outputs
    
    private let _rxSignUpResult = PublishSubject<Result<Void,Error>>()
    var rxSignUpResult: Observable<Result<Void,Error>> { _rxSignUpResult }
    
    // MARK: - Inputs
    
    func processUserSignUp(email: String, name: String, password: String, repeatPassword: String) {
        if !formModelValidator.isNameValid(name: name) {
            _rxSignUpResult.onNext(.failure(FormError.nameNotValid))
            return
        }
        
        if !formModelValidator.isEmailValid(email: email) {
            _rxSignUpResult.onNext(.failure(FormError.emailNotValid))
            return
        }
        
        if !formModelValidator.doPasswordMatch(password: password, repeatPassword: repeatPassword) {
            _rxSignUpResult.onNext(.failure(FormError.passwordDoNotMatch))
            return
        }
        
        if !formModelValidator.isPasswordValid(password: password) {
            _rxSignUpResult.onNext(.failure(FormError.passwordNotValid))
            return
        }
        
        do {
            try repository.saveUserCredentials(email: email, name: name, password: password)
            _rxSignUpResult.onNext(.success(()))
        } catch {
            if let error = error as? CoreDataManagerError, error == CoreDataManagerError.emailAlreadyExists {
                _rxSignUpResult.onNext(.failure(FormError.emailAlreadyExists))
            } else {
                _rxSignUpResult.onNext(.failure(error))
            }
        }
    }
}
