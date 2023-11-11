//
//  RecipeListRepositoryIntegrationTest.swift
//  Recipes-BH-iOSTests
//
//  Created by Martin Brianto on 11/11/23.
//

import XCTest
import RxSwift
@testable import Recipes_BH_iOS

final class RecipeListRepositoryIntegrationTests: XCTestCase {
    
    var apiClient: ApiClient!
    var repository: RecipeListRepositoryImpl!
    
    override func setUpWithError() throws {
        apiClient = ApiClientImpl()
        repository = RecipeListRepositoryImpl(apiClient: apiClient)
    }

    override func tearDownWithError() throws {
        apiClient = nil
        repository = nil
    }

    func testRecipeListRepository_shouldSuccessfulyGetResult() {
        // Arrange
        let firstLetter: Character = "A"

        // Act
        let observable = repository.getRecipeList(firstLetter: firstLetter)
        let expectation = XCTestExpectation(description: "Recipe list received")
        var result: [RecipeDetail]?

        // Assert
        _ = observable.subscribe(onNext: { recipes in
            result = recipes
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10.0)

        XCTAssertNotNil(result, "Result list should NOT be NIL")
    }
}
