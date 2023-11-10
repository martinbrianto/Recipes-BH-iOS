//
//  SignUpRepository.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import Foundation

protocol SignUpRepository {
    init(coreDataManager: CoreDataManager)
    func saveUserCredentials(email: String, name: String, password: String) throws
}

final class SignUpRepositoryImpl: SignUpRepository {
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManagerImpl()) {
        self.coreDataManager = coreDataManager
    }
    
    func saveUserCredentials(email: String, name: String, password: String) throws {
        do {
             try coreDataManager.saveUserCredential(email: email, name: name, password: password)
        } catch {
            throw error
        }
    }
}
