//
//  Constants.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/06/24.
//

import Foundation

enum K {
    static let weatherCellID = "weatherCellID"
    static let weatherHeaderID = "weatherHeaderID"
    enum LocalizedLabelStringFormat {
        static let myLocation = "My Location(%@)".localized
        static let temperature = "Temperature: %d˚C".localized
        static let humidity = "Humidity: %d%".localized
        static let updatedTime = "updated time: %@".localized
        static let currentTemperature = "current temperature: %d˚C".localized
        static let feelingTemperature = "feeling temperature: %d˚C".localized
        static let currentHumidity = "current humidity: %d%%".localized
        static let minimumTemperature = "minimum Temperature: %d˚C".localized
        static let maximumTemperature = "maximum Temperature: %d˚C".localized
        static let airPressure = "air pressure: %dhPa".localized
        static let windSpeed = "wind speed: %dm/s".localized
    }
    static let cities = [
        "Gongju",
        "Gwangju",
        "Gumi",
        "Gunsan",
        "Daegu",
        "Daejeon",
        "Mokpo",
        "Busan",
        "Seosan",
        "Seoul",
        "Sokcho",
        "Suwon",
        "Suncheon",
        "Ulsan",
        "Iksan",
        "Jeonju",
        "Jeju",
        "Cheonan",
        "Cheongju",
        "Chuncheon"
    ]
}
