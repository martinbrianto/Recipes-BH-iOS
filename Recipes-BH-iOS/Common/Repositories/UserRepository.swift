//
//  UserRepository.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import Foundation

protocol UserRepository {
    init(coreDataManager: CoreDataManager, userDefault: UserDefaults)
    func saveUserCredentials(forEmail email: String)
    func removeUserCredentials()
    func getUserCredential() -> String?
    
}

final class UserRepositoryImpl: UserRepository {
    
    private let coreDataManager: CoreDataManager
    private let userDefault: UserDefaults
    
    init(coreDataManager: CoreDataManager = CoreDataManagerImpl(), userDefault: UserDefaults = UserDefaults.standard) {
        self.userDefault = userDefault
        self.coreDataManager = coreDataManager
    }
    
    func saveUserCredentials(forEmail email: String) {
        if let userCredential = coreDataManager.getUserCredential(email: email), let userName = userCredential.name {
            userDefault.set(userName, forKey: UserDefaultKeys.loggedInUserName.rawValue)
        }
    }
    
    func removeUserCredentials() {
        userDefault.removeObject(forKey: UserDefaultKeys.loggedInUserName.rawValue)
    }
    
    func getUserCredential() -> String? {
        return userDefault.string(forKey: UserDefaultKeys.loggedInUserName.rawValue)
    }
}
