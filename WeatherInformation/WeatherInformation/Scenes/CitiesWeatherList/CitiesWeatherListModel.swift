//
//  CitiesWeatherListModel.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/30.
//

import Foundation
import CoreLocation
import UIKit

protocol CitiesWeatherListModelDelegate: AnyObject {
    func didUpdateWeatherData()
    func didFailWithError(error: NetworkManagerError)
}

class CitiesWeatherListModel {
    private let networkManager = NetworkManager.shared
    
    private(set) var simpleWeathers: [SimpleWeather] = []
    private(set) var myLocationWeather: DetailWeather?
    private var myLocationInformation: CLLocation?
    
    weak var delegate: CitiesWeatherListModelDelegate?
    
    func getWeatherData() {
        let group = DispatchGroup()
        
        group.enter()
        getSimpleWeatherInformation { [weak self] result in
            switch result {
                case .success():
                    break
                case .failure(let error):
                    self?.delegate?.didFailWithError(error: error)
            }
            group.leave()
        }
        
        group.enter()
        getMyLocationWeather { [weak self] result in
            switch result {
                case .success():
                    break
                case .failure(let error):
                    self?.delegate?.didFailWithError(error: error)
            }
            group.leave()
        }
        
        group.notify(queue: .global()) {
            self.translateCityName { [weak self] result in
                switch result {
                    case .success():
                        self?.delegate?.didUpdateWeatherData()
                    case .failure(let error):
                        self?.delegate?.didFailWithError(error: error)
                }
            }
        }
    }
    
    private func getSimpleWeatherInformation(
        completion: @escaping (Result<Void, NetworkManagerError>) -> Void
    ) {
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
        var networkError: NetworkManagerError?
        var fetchedSimpleWeathers: [SimpleWeather] = []
        K.cities.forEach { cityName in
            group.enter()
            networkManager.fetchWeather(.simpleWeather, cityName: cityName) { result in
                switch result {
                    case .success(let simpleWeather):
                        semaphore.wait()
                        guard let _simpleWeather = simpleWeather as? SimpleWeather else {
                            semaphore.signal()
                            group.leave()
                            return
                        }
                        fetchedSimpleWeathers.append(_simpleWeather)
                        semaphore.signal()
                        group.leave()
                    case .failure(let error):
                        networkError = error
                        group.leave()
                        return
                }
            }
        }
        group.notify(queue: .global()) { [weak self] in
            if let networkError = networkError {
                completion(.failure(networkError))
            }
            self?.simpleWeathers = fetchedSimpleWeathers.sorted(
                by: { $0.cityName.localized < $1.cityName.localized }
            )
            completion(.success(()))
        }
    }
    
    private func getMyLocationWeather(
        completion: @escaping (Result<Void, NetworkManagerError>) -> Void
    ) {
        guard let myLocationInformation = myLocationInformation else {
            return
        }

        let latitude = String(myLocationInformation.coordinate.latitude)
        let longitude = String(myLocationInformation.coordinate.longitude)
        networkManager.fetchWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
                case .success(let detailWeather):
                    self?.myLocationWeather = detailWeather
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    private func translateCityName(
        completion: @escaping (Result<Void, NetworkManagerError>) -> Void
    ) {
        guard let translatingCityName = myLocationWeather?.cityName else {
            return
        }
        networkManager.fetchTranslatedText(translatingCityName) { [weak self] result in
            switch result {
                case .success(let cityName):
                    self?.myLocationWeather?.cityName = cityName
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func setMyLocationInformation(currentLocation: CLLocation) {
        myLocationInformation = currentLocation
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
