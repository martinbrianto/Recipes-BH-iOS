//
//  SignUpError.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import Foundation

enum FormError: Error {
    case nameNotValid
    case emailNotValid
    case passwordDoNotMatch
    case passwordNotValid
    case emailAlreadyExists
    
    var description: String {
        switch self {
        case .nameNotValid:
            return "Nama tidak boleh kurang dari \(SignUpConstants.nameMinLength) dan tidak boleh lebih dari \(SignUpConstants.nameMaxLength) karakter"
        case .emailNotValid:
            return "Email tidak valid"
        case .passwordDoNotMatch:
            return "Password dan konfirmasi password tidak sama"
        case .passwordNotValid:
            return "Password tidak boleh kurang dari \(SignUpConstants.passwordMinLength) dan tidak boleh lebih dari \(SignUpConstants.passwordMaxLength) karakter"
        case .emailAlreadyExists:
            return "Email yang di input sudah terdaftar"
        }
    }
}
