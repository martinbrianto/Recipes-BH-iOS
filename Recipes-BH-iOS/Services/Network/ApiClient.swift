//
//  ApiClient.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import Foundation
import RxSwift
import Alamofire

protocol ApiClient {
    func getString(_ endPoint: String,
                   params: [String: Any]) -> Observable<String>
}

final class ApiClientImpl: ApiClient {
    
    private func getBaseUrl() -> String {
        return "https://www.themealdb.com/api/json/v1/1"
    }
    
    private func composeUrl(host: String, path: String) -> String? {
        var url = URL(string: host)
        url?.appendPathComponent(path)
        
        return url?.absoluteString
    }
    
    func getString(_ endPoint: String, params: [String : Any]) -> Observable<String> {
        
        let urlString: String? = self.composeUrl(host: self.getBaseUrl(), path: endPoint)
        
        return Observable.create { observer in
            guard let urlString = urlString else { return Disposables.create {}}

            let request = AF.request(urlString,
                                     method: .get,
                                     parameters: params,
                                     encoding: URLEncoding.default)
            
            request.responseData { response in
                if let error = response.error {
                    print(error)
                    observer.on(.error(error))
                    return
                }
                
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode < 200 || statusCode >= 300 {
                    let apiError: NetworkError
                    switch statusCode {
                    case 400:
                        apiError = .badRequest("Invalid request")
                    case 402:
                        apiError = .requestFailed("Request failed")
                    case 403:
                        apiError = .forbidden("Forbidden request")
                    case 404:
                        apiError = .notFound("Resource not found")
                    case 429:
                        apiError = .tooManyRequests("Rate limit exceeded")
                    case 500, 502, 503, 504:
                        apiError = .serverError("Server error occurred")
                    default:
                        apiError = .serverError("Unknown server error")
                    }
                    print(apiError)
                    observer.on(.error(apiError))
                    return
                }
                
                guard let data = response.value else { return }
                if let responseString = String(data: data, encoding: .utf8) {
                    observer.on(.next(responseString))
                    observer.on(.completed)
                }
                else if let asciiResponse = String(data: data, encoding: .ascii),
                    let asciiData = asciiResponse.data(using: .utf8),
                    let responseString = String(data: asciiData, encoding: .utf8) {
                    observer.on(.next(responseString))
                    observer.on(.completed)
                }
            }
            
            return Disposables.create()
        }
    }
}
