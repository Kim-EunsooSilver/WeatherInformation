//
//  WeatherDetailModel.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/31.
//

import UIKit

protocol WeatherDetailModelDelegate: AnyObject {
    func didUpdateWeatherData()
    func didFailWithError(error: NetworkManagerError)
}

class WeatherDetailModel {
    private let networkManager = NetworkManager.shared
    
    private let cityName: String
    private(set) var detailWeather: DetailWeather?
    
    weak var delegate: WeatherDetailModelDelegate?
    
    init(cityName: String) {
        self.cityName = cityName
    }
    
    func getWeatherData() {
        networkManager.fetchWeather(.detailWeather, cityName: cityName) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
                case .success(let weatherData):
                    guard let detailWeather = weatherData as? DetailWeather else {
                        return
                    }
                    self.detailWeather = detailWeather
                    self.delegate?.didUpdateWeatherData()
                case .failure(let error):
                    self.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    func getWeatherIcon(iconName: String, completion: @escaping (UIImage) -> Void) {
        networkManager.fetchWeatherIcon(iconName: iconName) { result in
            switch result {
                case .success(let iconImage):
                    completion(iconImage)
                case .failure(_):
                    guard let failImage = UIImage(systemName: "exclamationmark.triangle") else {
                        return
                    }
                    completion(failImage)
            }
        }
    }

}
