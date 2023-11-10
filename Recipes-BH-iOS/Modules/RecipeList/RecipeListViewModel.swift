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
    init(repository: RecipeListRepository)
    
    var recipes: [RecipeDetail] { get }
    var recipeFirstLetterParam: Character { get }
    var rxViewState: Observable<RecipeListViewState> { get }
    var rxFirstLetterParam: Observable<Character> { get }
    
    func changeFirstLetterParam(to character: Character)
    func getRecipeList()
}

final class RecipeListViewModelImpl: RecipeListViewModel {
    
    // MARK: - Variables
    private let repository: RecipeListRepository
    private var recipeListDisposeBag = DisposeBag()
    
    var recipeFirstLetterParam: Character = "A" {
        didSet {
            _rxFirstLetterParam.onNext(recipeFirstLetterParam)
        }
    }
    var recipes: [RecipeDetail] = []
    
    // MARK: - Inits
    init(repository: RecipeListRepository = RecipeListRepositoryImpl()) {
        self.repository = repository
    }
    
    // MARK: - Outputs
    
    private let _rxViewState = PublishSubject<RecipeListViewState>()
    var rxViewState: Observable<RecipeListViewState> { _rxViewState }
    
    private let _rxFirstLetterParam = PublishSubject<Character>()
    var rxFirstLetterParam: Observable<Character> { _rxFirstLetterParam }
    
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
}
