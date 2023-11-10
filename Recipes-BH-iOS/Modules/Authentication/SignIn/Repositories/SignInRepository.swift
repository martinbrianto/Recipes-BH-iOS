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
}
