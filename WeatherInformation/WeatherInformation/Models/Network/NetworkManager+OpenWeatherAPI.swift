//
//  OpenWeatherAPI.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/29.
//

import Foundation

extension NetworkManager {
    struct OpenWeatherAPI {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        
        static let weatherPath = "/data/2.5/weather"
        static let iconPath = "/img/wn/%@@2x.png"
        
        static let apiKey = "d8cae5e810621d48d8d9a6c297cfa910"
        
        static let languageCode = LanguageCode().rawValue
    }
}
