//
//  WeatherData.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/06/27.
//

import Foundation

struct WeatherData: Decodable {
    let main: Main
    let weather: [Weather]
    let name: String
    let wind: Wind
    let timeOfData: Int
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case name
        case wind
        case timeOfData = "dt"
    }
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Int
}

struct Weather: Decodable {
    let icon: String
    let description: String
}

struct Wind: Decodable {
    let speed: Double
}
