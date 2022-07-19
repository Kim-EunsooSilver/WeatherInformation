//
//  CacheManager.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/04.
//

import UIKit

final class CacheManager {
    private static let imageCache = NSCache<NSString, UIImage>()
    private init() {
        
    }

    static func getWeatherIcon(iconName: String, completion: @escaping (UIImage) -> Void) {
        let cacheKey = NSString(string: iconName)
        
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        NetworkManager.shared.fetchWeatherIcon(iconName: iconName) { result in
            switch result {
                case .failure(_):
                    guard let failImage = UIImage(systemName: "exclamationmark.triangle") else {
                        return
                    }
                    completion(failImage)
                case .success(let data):
                    guard let iconImage = UIImage(data: data) else {
                        return
                    }
                    imageCache.setObject(iconImage, forKey: cacheKey)
                    completion(iconImage)
            }
        }
    }
}
