//
//  GoogleTransitionAPI.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/30.
//

import Foundation

extension NetworkManager {
    struct GoogleTransitionAPI {
        static let scheme = "https"
        static let host = "translation.googleapis.com"
        static let path = "/language/translate/v2"
        static let apiKey = "AIzaSyA8JmRyNQZtmIDfMu5MJK7AhOpHNgQ41ic"
    }
    
    func getTranslateURLComponents(
        targetText: String,
        targetLanguageCode: String,
        sourceLanguageCode: String
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = GoogleTransitionAPI.scheme
        components.host = GoogleTransitionAPI.host
        components.path = GoogleTransitionAPI.path
        
        components.queryItems = [
            URLQueryItem(name: "key", value: GoogleTransitionAPI.apiKey),
            URLQueryItem(name: "q", value: targetText),
            URLQueryItem(name: "target", value: targetLanguageCode),
            URLQueryItem(name: "source", value: sourceLanguageCode)
        ]
        return components
    }

}

