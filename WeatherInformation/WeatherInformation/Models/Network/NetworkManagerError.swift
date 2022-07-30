//
//  NetworkManagerError.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/30.
//

import Foundation

enum NetworkManagerError: Error {
    case urlError
    case networkError
    case responseError
    case dataError
    case parseError
}
