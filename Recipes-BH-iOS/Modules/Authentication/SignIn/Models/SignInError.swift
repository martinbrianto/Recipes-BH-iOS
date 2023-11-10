//
//  SignInError.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import Foundation

enum SignInError: Error {
    case passwordDoNotMatch
    
    var description: String {
        switch self {
        case .passwordDoNotMatch:
            return "Email atau password salah, periksa kembali"
        }
    }
}
