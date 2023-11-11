//
//  MockApiClient.swift
//  Recipes-BH-iOSTests
//
//  Created by Martin Brianto on 11/11/23.
//

import Foundation
import RxSwift

@testable import Recipes_BH_iOS

class MockApiClient: ApiClient {
    var mockGetStringResult: Observable<String> = Observable.never()
    
    func getString(_ endPoint: String, params: [String : Any]) -> Observable<String> {
        return mockGetStringResult
    }
}
