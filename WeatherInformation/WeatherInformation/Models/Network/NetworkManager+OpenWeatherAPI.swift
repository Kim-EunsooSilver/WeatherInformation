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
    func getWeatherURLComponents(cityName: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.weatherPath
        
        components.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: OpenWeatherAPI.languageCode),
            URLQueryItem(name: "appid", value: OpenWeatherAPI.apiKey)
        ]
        return components
    }
    
    func getWeatherURLComponents(latitude: String, longitude: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.weatherPath
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: latitude),
            URLQueryItem(name: "lon", value: longitude),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: OpenWeatherAPI.languageCode),
            URLQueryItem(name: "appid", value: OpenWeatherAPI.apiKey)
        ]
        return components
    }
    
    func getWeatherIconURLComponents(iconName: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = "openweathermap.org"
        components.path = String(format: OpenWeatherAPI.iconPath, iconName)
        return components
    }


}
