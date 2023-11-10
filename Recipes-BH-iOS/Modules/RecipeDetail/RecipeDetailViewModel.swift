//
//  RecipeDetailViewModel.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import Foundation
import RxSwift

enum RecipeDetailViewState {
    case loaded
    case loading
    case error(String)
}

protocol RecipeDetailViewModel {
    init(recipeId: String, repository: RecipeDetailRepository)
    
    var recipesDetail: RecipeDetail { get }
    var rxViewState: Observable<RecipeListViewState> { get }
    
    func getRecipeDetail()
}

final class RecipeDetailViewModelImpl: RecipeDetailViewModel {
    
    // MARK: - Variables
    
    private let recipeId: String
    private let repository: RecipeDetailRepository
    private var recipeDetailDisposeBag = DisposeBag()
    
    var recipesDetail: RecipeDetail = RecipeDetail.emptyRecipe
    
    // MARK: - Inits
    init(recipeId: String, repository: RecipeDetailRepository = RecipeDetailRepositoryImpl()) {
        self.repository = repository
        self.recipeId = recipeId
    }
    // MARK: - Outputs
    
    private let _rxViewState = PublishSubject<RecipeListViewState>()
    var rxViewState: Observable<RecipeListViewState> { _rxViewState }
    
    // MARK: - Inputs
    
    func getRecipeDetail() {
        repository.getRecipeDetail(for: recipeId)
            .subscribe(onNext: { [weak self] detailResponse in
                self?.recipesDetail = detailResponse
                self?._rxViewState.onNext(.loaded)
            }, onError: { [weak self] error in
                if let error = error as? NetworkError {
                    self?._rxViewState.onNext(.error(error.description))
                } else {
                    self?._rxViewState.onNext(.error(error.localizedDescription))
                }
            })
            .disposed(by: recipeDetailDisposeBag)
    }
}
