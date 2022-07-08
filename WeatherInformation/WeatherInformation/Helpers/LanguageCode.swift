//
//  RegionCode.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/08.
//

import Foundation

enum LanguageCode: String {
    case korean = "kr"
    case japanese = "ja"
    case english = "en"
    
    init() {
        switch Locale.current.languageCode {
            case "ko":
                self = .korean
            case "ja":
                self = .japanese
            default:
                self = .english
        }
    }
}
