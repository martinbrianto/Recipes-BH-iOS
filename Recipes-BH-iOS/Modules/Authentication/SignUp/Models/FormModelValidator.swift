//
//  SignUpFormModelValidator.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import Foundation

protocol FormModelValidator {
    func isNameValid(name: String) -> Bool
    func isEmailValid(email: String) -> Bool
    func isPasswordValid(password: String) -> Bool
    func doPasswordMatch(password: String, repeatPassword: String) -> Bool
}

final class FormModelValidatorImpl: FormModelValidator {
    func isNameValid(name: String) -> Bool {
        return name.count >= SignUpConstants.nameMinLength && name.count <= SignUpConstants.nameMaxLength
    }
    
    func isEmailValid(email: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: email)
    }
    
    func isPasswordValid(password: String) -> Bool {
        return password.count >= SignUpConstants.passwordMinLength && password.count <= SignUpConstants.passwordMaxLength
    }
    
    func doPasswordMatch(password: String, repeatPassword: String) -> Bool {
        return password == repeatPassword
    }
}
