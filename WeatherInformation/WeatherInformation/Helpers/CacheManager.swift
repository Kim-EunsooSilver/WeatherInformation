//
//  CacheManager.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/04.
//

import UIKit

final class CacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {
        
    }

    static func getWeatherIcon(iconName: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: iconName)
        
        if let cachedImage = Self.shared.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        NetworkManager.shared.fetchWeatherIcon(iconName: iconName) { result in
            switch result {
                case .failure(_):
                    completion(UIImage(systemName: "exclamationmark.triangle"))
                case .success(let data):
                    guard let iconImage = UIImage(data: data) else {
                        return
                    }
                    Self.shared.setObject(iconImage, forKey: cacheKey)
                    completion(iconImage)
            }
        }
    }
}
