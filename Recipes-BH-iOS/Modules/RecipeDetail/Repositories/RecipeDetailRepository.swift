//
//  RecipeDetailRepository.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import Foundation
import RxSwift

protocol RecipeDetailRepository {
    init(apiClient: ApiClient)
    func getRecipeDetail(for id: String) -> Observable<RecipeDetail>
}

final class RecipeDetailRepositoryImpl: RecipeDetailRepository {
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient = ApiClientImpl()) {
        self.apiClient = apiClient
    }
    
    func getRecipeDetail(for id: String) -> Observable<RecipeDetail> {
        let params: [String:Any] = [
            "i":id,
        ]
        
        return apiClient.getString("/lookup.php", params: params)
            .asObservable()
            .flatMap{ jsonString -> Observable<RecipeList> in
                jsonString.toRxCodable()
            }
            .map({$0.meals?.first ?? .emptyRecipe})
    }
    
}

