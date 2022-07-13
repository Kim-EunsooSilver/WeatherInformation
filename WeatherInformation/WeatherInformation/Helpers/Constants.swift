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
    enum OpenWeather {
        static let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d8cae5e810621d48d8d9a6c297cfa910&units=metric"
        static let iconURL = "https://openweathermap.org/img/wn/"
        static let imageSize2x = "@2x.png"
    }
}
