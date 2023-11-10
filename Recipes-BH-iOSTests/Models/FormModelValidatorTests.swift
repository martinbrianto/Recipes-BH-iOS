//
//  SignUpFormModelValidatorTests.swift
//  Recipes-BH-iOSTests
//
//  Created by Martin Brianto on 09/11/23.
//

import XCTest
@testable import Recipes_BH_iOS

final class FormModelValidatorTests: XCTestCase {
    
    var sut: FormModelValidator!

    override func setUpWithError() throws {
        sut = FormModelValidatorImpl()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Name
    
    func testSignUpFormModelValidator_whenValidFirstNameIsProvided_shouldReturnTrue() {
        //Arrange
        //Act
        let isNameValid = sut.isNameValid(name: "Martin")
        //Assert / Then
        XCTAssertTrue(isNameValid, "The isFirstNameValid() should've returned TRUE for a valid first name but returned FALSE")
    }
    
    func testSIgnUpFormModelValidator_whenTooShortFirstNameIsProvided_shouldReturnFalse() {
        // Arrange
        // Act
        let isNameValid = sut.isNameValid(name: "M")
        // Assert
        XCTAssertFalse(isNameValid, "The isFirstNameValid should've returned FALSE for first name that is shorter than \(SignUpConstants.nameMinLength) characters")
    }
    
    
    func testSignUpFormModelValidator_whenTooLongFirstNameIsProvided_shouldReturnFalse() {
        // Arrange
        // Act
        let isNameValid = sut.isNameValid(name: "MartinMartinMartin")
        // Assert
        XCTAssertFalse(isNameValid, "The isFirstNameValid should've return FALSE for first name that is longer than \(SignUpConstants.nameMaxLength) characters")
    }
    
    // MARK: - Email
    
    func testSignUpFormModelValidator_whenValidEmailIsProvided_shouldReturnTrue() {
        // Arrange
        // Act
        let isEmailValid = sut.isEmailValid(email: "email@providder.com")
        // Assert
        XCTAssertTrue(isEmailValid, "The isEmailValid should've returned TRUE for valid email but returned FALSE")
    }
    
    func testSignUpFormModelValidator_whenInvalidEmailIsProvided_shouldReturnFalse() {
        // Arrange
        // Act
        let isEmailValid = sut.isEmailValid(email: "email@@@providder")
        // Assert
        XCTAssertFalse(isEmailValid, "The isEmailValid should've returned FALSE for invalid email but returned TRUE")
    }
    
    // MARK: - Password
    
    func testSignUpFormModelValidator_whenValidPasswordIsProvided_shouldReturnTrue() {
        // Arrange
        // Act
        let isPasswordValid = sut.isPasswordValid(password: "12345678")
        // Assert
        XCTAssertTrue(isPasswordValid, "The isPasswordValid() should've return TRUE for valid password buat return FALSE")
    }
    
    func testSignUpFormModelValidator_whenTooShortPasswordIsProvided_shouldReturnFalse() {
        // Arrange
        // Act
        let isPasswordValid = sut.isPasswordValid(password: "123")
        // Assert
        XCTAssertFalse(isPasswordValid, "The isPasswordValid() should've return FALSE for  password that are shorter than \(SignUpConstants.passwordMinLength) buat return TRUE")
    }
    
    func testSignUpFormModelValidator_whenTooLongPasswordIsProvided_shouldReturnFalse() {
        // Arrange
        // Act
        let isPasswordValid = sut.isPasswordValid(password: "1239871239812739812739")
        // Assert
        XCTAssertFalse(isPasswordValid, "The isPasswordValid() should've return FALSE for  password that are longer than \(SignUpConstants.passwordMaxLength) buat return TRUE")
    }
    
    // MARK: - Confirm Password
    func testSignUpFormModelValidator_whenSamePasswordProvided_shouldReturnTrue() {
        // Arrange
        // Act
        let doPasswordMatch = sut.doPasswordMatch(password: "12345678", repeatPassword: "12345678")
        // Assert
        XCTAssertTrue(doPasswordMatch, "the doPasswordMatch() should've return TRUE when password and repeat password are the same")
    }
    
    func testSignUpFormModelValidator_whenDifferentPasswordProvided_shouldReturnFalse() {
        // Arrange
        // Act
        let doPasswordMatch = sut.doPasswordMatch(password: "12345678", repeatPassword: "1234578")
        // Assert
        XCTAssertFalse(doPasswordMatch, "the doPasswordMatch() should've return FALSE when password and repeat password are NOT the same")
    }
}
