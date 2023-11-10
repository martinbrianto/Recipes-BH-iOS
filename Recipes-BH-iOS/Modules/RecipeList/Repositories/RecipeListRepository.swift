//
//  RecipeListRepository.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import Foundation
import RxSwift

protocol RecipeListRepository {
    init(apiClient: ApiClient)
    func getRecipeList(firstLetter: Character) -> Observable<[RecipeDetail]>
}

final class RecipeListRepositoryImpl: RecipeListRepository {
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient = ApiClientImpl()) {
        self.apiClient = apiClient
    }
    
    func getRecipeList(firstLetter: Character) -> Observable<[RecipeDetail]> {
        let params: [String:Any] = [
            "f":firstLetter,
        ]
        
        return apiClient.getString("/search.php", params: params)
            .asObservable()
            .flatMap{ jsonString -> Observable<RecipeList> in
                jsonString.toRxCodable()
            }
            .map({$0.meals ?? []})
    }
    
}
