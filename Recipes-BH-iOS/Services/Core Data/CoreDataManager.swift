//
//  CoreDataManager.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import CoreData

enum CoreDataManagerError: Error {
    case emailAlreadyExists
}

protocol CoreDataManager {
    @discardableResult func saveUserCredential(email: String, name: String, password: String) throws -> UserCredential
    func getUserCredential(email: String) -> UserCredential?
    func verifyPassword(forEmail email: String, password: String) -> Bool
}

final class CoreDataManagerImpl: CoreDataManager {
    
    // MARK: - Variables
    
    private let persistentContainer: NSPersistentContainer
    
    // MARK: - Inits
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Recipes_BH_iOS")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    @discardableResult
    func saveUserCredential(email: String, name: String, password: String) throws -> UserCredential {
        let email = email.lowercased() //lowercase email to make case insensitive
        
        let context = persistentContainer.viewContext
        
        // Check if the email already exists
        if getUserCredential(email: email) != nil {
            throw CoreDataManagerError.emailAlreadyExists
        }
        
        let userCredential = UserCredential(context: context)
        userCredential.email = email
        userCredential.name = name
        userCredential.password = password
        
        do {
            try context.save()
        } catch {
            throw error // Re-throw the error to the caller
        }
        
        return userCredential
    }
    
    func verifyPassword(forEmail email: String, password: String) -> Bool {
        let email = email.lowercased() //lowercase email to make case insensitive
        
        if let userCredential = getUserCredential(email: email) {
            return userCredential.password == password
        }
        return false
    }
    
    func getUserCredential(email: String) -> UserCredential? {
        let email = email.lowercased() //lowercase email to make case insensitive
        
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserCredential> = UserCredential.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            fatalError("Failed to fetch user credential: \(error)")
        }
    }
}
