//
//  RecipeDetailRepositoryIntegrationTest.swift
//  Recipes-BH-iOSTests
//
//  Created by Martin Brianto on 11/11/23.
//

import XCTest
import RxSwift
@testable import Recipes_BH_iOS

final class RecipeDetailRepositoryIntegrationTest: XCTestCase {
    
    var apiClient: ApiClient!
    var repository: RecipeDetailRepository!
    
    override func setUpWithError() throws {
        apiClient = ApiClientImpl()
        repository = RecipeDetailRepositoryImpl(apiClient: apiClient)
    }

    override func tearDownWithError() throws {
        apiClient = nil
        repository = nil
    }

    func testRecipeListRepository_shouldSuccessfulyGetResult() throws {
        // Arrange
        let recipeId = "52768"

        // Act
        let observable = repository.getRecipeDetail(for: recipeId)
        let expectation = XCTestExpectation(description: "Recipe detail received")
        var result: RecipeDetail?

        // Assert
        _ = observable.subscribe(onNext: { recipeDetail in
            result = recipeDetail
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10.0)
        
        let detailRecipe = try XCTUnwrap(result, "Result should NOT be NIL when valid id")
        XCTAssertEqual(detailRecipe.strMeal, "Apple Frangipan Tart", "recipe name should be Apple Frangipan Tart")
    }
    
    func testRecipeListRepository_shouldReturnEmptyRecipe_whenInvalidIdProvided() throws {
        // Arrange
        let recipeId = "xxxxx123"

        // Act
        let observable = repository.getRecipeDetail(for: recipeId)
        let expectation = XCTestExpectation(description: "Recipe detail received")
        var result: RecipeDetail?

        // Assert
        _ = observable.subscribe(onNext: { recipeDetail in
            result = recipeDetail
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertEqual(result, RecipeDetail.emptyRecipe, "Result should equal to .emptyRecipe when invalid id is provided")
    }
}
