//
//  TranslationData.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/13.
//

import Foundation

struct TranslationData: Decodable {
    let data: TranslatedData
}

struct TranslatedData: Decodable {
    let translations: [Translation]
}

struct Translation: Decodable {
    let translatedText: String
}
