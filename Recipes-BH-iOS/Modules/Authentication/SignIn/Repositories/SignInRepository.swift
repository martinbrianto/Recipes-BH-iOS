//
//  SignInRepository.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import Foundation

protocol SignInRepository {
    init(coreDataManager: CoreDataManager, userDefault: UserDefaults)
    func isPasswordValid(forEmail email: String, password: String) -> Bool
    func saveLoggedInUserCredentials(forEmail email: String)
}

final class SignInRepositoryImpl: SignInRepository {
    private let coreDataManager: CoreDataManager
    private let userDefault: UserDefaults
    
    init(coreDataManager: CoreDataManager = CoreDataManagerImpl(), userDefault: UserDefaults = UserDefaults.standard) {
        self.userDefault = userDefault
        self.coreDataManager = coreDataManager
    }
    
    func isPasswordValid(forEmail email: String, password: String) -> Bool {
        return coreDataManager.verifyPassword(forEmail: email, password: password)
    }
    
    func saveLoggedInUserCredentials(forEmail email: String) {
        if let userCredential = coreDataManager.getUserCredential(email: email), let userName = userCredential.name {
            userDefault.set(userName, forKey: UserDefaultKeys.loggedInUserName.rawValue)
        }
    }
}
