//
//  RecipeListViewModel.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import Foundation
import RxSwift

enum RecipeListViewState {
    case loading
    case loaded
    case error(String)
}

protocol RecipeListViewModel {
    init(repository: RecipeListRepository, userRepository: UserRepository)
    
    var recipes: [RecipeDetail] { get }
    var recipeFirstLetterParam: Character { get }
    var rxViewState: Observable<RecipeListViewState> { get }
    var rxUserDidLogout: Observable<Void> { get }
    var rxFirstLetterParam: Observable<Character> { get }
    
    func changeFirstLetterParam(to character: Character)
    func getRecipeList()
    func logOutUser()
    func getUserName() -> String
}

final class RecipeListViewModelImpl: RecipeListViewModel {
    
    // MARK: - Variables
    private let repository: RecipeListRepository
    private let userRepository: UserRepository
    private var recipeListDisposeBag = DisposeBag()
    
    var recipeFirstLetterParam: Character = "A" {
        didSet {
            _rxFirstLetterParam.onNext(recipeFirstLetterParam)
        }
    }
    var recipes: [RecipeDetail] = []
    
    // MARK: - Inits
    init(repository: RecipeListRepository = RecipeListRepositoryImpl(), userRepository: UserRepository = UserRepositoryImpl()) {
        self.repository = repository
        self.userRepository = userRepository
    }
    
    // MARK: - Outputs
    
    private let _rxViewState = PublishSubject<RecipeListViewState>()
    var rxViewState: Observable<RecipeListViewState> { _rxViewState }
    
    private let _rxFirstLetterParam = PublishSubject<Character>()
    var rxFirstLetterParam: Observable<Character> { _rxFirstLetterParam }
    
    private let _rxUserDidLogout = PublishSubject<Void>()
    var rxUserDidLogout: Observable<Void> { _rxUserDidLogout }
    
    // MARK: - Inputs
    func changeFirstLetterParam(to character: Character) {
        self.recipeFirstLetterParam = character
        getRecipeList()
    }
    
    func getRecipeList() {
        recipeListDisposeBag = DisposeBag()
        
        _rxViewState.onNext(.loading)
        
        repository.getRecipeList(firstLetter: self.recipeFirstLetterParam)
            .subscribe(onNext: { [weak self] responseRecipes in
                self?.recipes = responseRecipes
                self?._rxViewState.onNext(.loaded)
            }, onError: { [weak self] error in
                if let error = error as? NetworkError {
                    self?._rxViewState.onNext(.error(error.description))
                } else {
                    self?._rxViewState.onNext(.error(error.localizedDescription))
                }
            })
            .disposed(by: recipeListDisposeBag)
    }
    
    func getUserName() -> String {
        return userRepository.getUserCredential() ?? ""
    }
    
    func logOutUser() {
        userRepository.removeUserCredentials()
        _rxUserDidLogout.onNext(())
    }
}
