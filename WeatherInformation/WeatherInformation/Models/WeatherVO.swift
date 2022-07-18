//
//  WeatherVO.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/18.
//

import Foundation


protocol WeatherVO {
    
}

enum WeatherInformation {
    case simpleWeather
    case detailWeather
}

struct SimpleWeather: WeatherVO {
    let cityName: String
    let iconName: String
    let currentTemperature: Int
    let currentHumidity: Int
}

struct DetailWeather: WeatherVO {
    var cityName: String
    let iconName: String
    let currentTemperature: Int
    let feelingTemperature: Int
    let currentHumidity: Int
    let minimumTemperature: Int
    let maximumTemperature: Int
    let airPressure: Int
    let windSpeed: Int
    let description: String
    let timeOfData: String
}
