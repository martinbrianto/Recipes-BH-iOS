//
//  RecipeListRepositoryTest.swift
//  Recipes-BH-iOSTests
//
//  Created by Martin Brianto on 11/11/23.
//

import XCTest
import RxSwift
@testable import Recipes_BH_iOS

final class RecipeListRepositoryTest: XCTestCase {
    
    var apiClient: MockApiClient!
    var repository: RecipeListRepositoryImpl!
    
    override func setUpWithError() throws {
        apiClient = MockApiClient()
        repository = RecipeListRepositoryImpl(apiClient: apiClient)
    }
    
    override func tearDownWithError() throws {
        apiClient = nil
        repository = nil
    }
    
    func testRecipeListRepository_shouldReturnRecipeList_whenValidStringIsParsed() {
        // Arrange
        let firstLetter: Character = "A"
        let jsonString = """
{\n\"meals\": [\n    {\n      \"idMeal\": \"52768\",\n      \"strMeal\": \"Apple Frangipan Tart\",\n      \"strDrinkAlternate\": null,\n      \"strCategory\": \"Dessert\",\n      \"strArea\": \"British\",\n      \"strInstructions\": \"Preheat the oven to 200C/180C Fan/Gas 6.\\r\\nPut the biscuits in a large re-sealable freezer bag and bash with a rolling pin into fine crumbs. Melt the butter in a small pan, then add the biscuit crumbs and stir until coated with butter. Tip into the tart tin and, using the back of a spoon, press over the base and sides of the tin to give an even layer. Chill in the fridge while you make the filling.\\r\\nCream together the butter and sugar until light and fluffy. You can do this in a food processor if you have one. Process for 2-3 minutes. Mix in the eggs, then add the ground almonds and almond extract and blend until well combined.\\r\\nPeel the apples, and cut thin slices of apple. Do this at the last minute to prevent the apple going brown. Arrange the slices over the biscuit base. Spread the frangipane filling evenly on top. Level the surface and sprinkle with the flaked almonds.\\r\\nBake for 20-25 minutes until golden-brown and set.\\r\\nRemove from the oven and leave to cool for 15 minutes. Remove the sides of the tin. An easy way to do this is to stand the tin on a can of beans and push down gently on the edges of the tin.\\r\\nTransfer the tart, with the tin base attached, to a serving plate. Serve warm with cream, crème fraiche or ice cream.\",\n      \"strMealThumb\": \"https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg\",\n      \"strTags\": \"Tart,Baking,Fruity\",\n      \"strYoutube\": \"https://www.youtube.com/watch?v=rp8Slv4INLk\",\n      \"strIngredient1\": \"digestive biscuits\",\n      \"strIngredient2\": \"butter\",\n      \"strIngredient3\": \"Bramley apples\",\n      \"strIngredient4\": \"butter, softened\",\n      \"strIngredient5\": \"caster sugar\",\n      \"strIngredient6\": \"free-range eggs, beaten\",\n      \"strIngredient7\": \"ground almonds\",\n      \"strIngredient8\": \"almond extract\",\n      \"strIngredient9\": \"flaked almonds\",\n      \"strIngredient10\": \"\",\n      \"strIngredient11\": \"\",\n      \"strIngredient12\": \"\",\n      \"strIngredient13\": \"\",\n      \"strIngredient14\": \"\",\n      \"strIngredient15\": \"\",\n      \"strIngredient16\": null,\n      \"strIngredient17\": null,\n      \"strIngredient18\": null,\n      \"strIngredient19\": null,\n      \"strIngredient20\": null,\n      \"strMeasure1\": \"175g/6oz\",\n      \"strMeasure2\": \"75g/3oz\",\n      \"strMeasure3\": \"200g/7oz\",\n      \"strMeasure4\": \"75g/3oz\",\n      \"strMeasure5\": \"75g/3oz\",\n      \"strMeasure6\": \"2\",\n      \"strMeasure7\": \"75g/3oz\",\n      \"strMeasure8\": \"1 tsp\",\n      \"strMeasure9\": \"50g/1¾oz\",\n      \"strMeasure10\": \"\",\n      \"strMeasure11\": \"\",\n      \"strMeasure12\": \"\",\n      \"strMeasure13\": \"\",\n      \"strMeasure14\": \"\",\n      \"strMeasure15\": \"\",\n      \"strMeasure16\": null,\n      \"strMeasure17\": null,\n      \"strMeasure18\": null,\n      \"strMeasure19\": null,\n      \"strMeasure20\": null,\n      \"strSource\": null,\n      \"strImageSource\": null,\n      \"strCreativeCommonsConfirmed\": null,\n      \"dateModified\": null\n    }\n]\n}
"""
        
        // Act
        apiClient.mockGetStringResult = Observable.just(jsonString)
        let observable = repository.getRecipeList(firstLetter: firstLetter)
        
        // Assert
        let expectation = XCTestExpectation(description: "Recipe list received")
        var result: [RecipeDetail]?
        
        _ = observable.subscribe(onNext: { recipes in
            result = recipes
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(result, "Result should NOT be NIL when valid jsonString is parsed")
        XCTAssertEqual(result?.count, 1, "The amount of recipes received parsed from jsonString should be 1")
    }
}
