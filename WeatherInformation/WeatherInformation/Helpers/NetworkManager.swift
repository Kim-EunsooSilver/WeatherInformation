//
//  NetworkManager.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/06/27.
//

import Foundation

enum NetworkManagerError: Error {
    case networkError
    case responseError
    case dataError
    case parseError
}

struct NetworkManager {

    static let shared = NetworkManager()

    private init() { }

    private func performRequest(
        with urlString: String,
        completion: @escaping (Result<Data, NetworkManagerError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            return
        }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.networkError))
                return
            }
            guard let _response = response as? HTTPURLResponse,
                (200 ..< 299) ~= _response.statusCode else {
                completion(.failure(.responseError))
                return
            }
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            completion(.success(safeData))
        }
        task.resume()
    }

    func fetchSimpleWeather(
        cityName: String,
        completion: @escaping (Result<SimpleWeather, NetworkManagerError>) -> Void
    ) {
        let urlString = "\(K.openWeatherURL)&q=\(cityName)"
        
        performRequest(with: urlString) { result in
            switch result {
                case .success(let data):
                    guard let simpleWeather = parseToSimpleWeather(data) else {
                        completion(.failure(.parseError))
                        return
                    }
                    completion(.success(simpleWeather))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    func fetchWeatherIcon(
        iconName: String,
        completion: @escaping (Result<Data, NetworkManagerError>) -> Void
    ) {
        let urlString = K.iconURL + iconName + K.imageSize2x
        performRequest(with: urlString) { result in
            switch result {
                case .success(let data):
                    completion(.success(data))
                    return
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func fetchDetailWeather(
        cityName: String,
        completion: @escaping (Result<DetailWeather, NetworkManagerError>) -> Void
    ) {
        guard let regionCode = Locale.current.languageCode else {
            return
        }
        let urlString = "\(K.openWeatherURL)&q=\(cityName)&lang=\(regionCode)"
        
        performRequest(with: urlString) { result in
            switch result {
                case .success(let data):
                    guard let detailWeather = parseToDetailWeather(data) else {
                        completion(.failure(.parseError))
                        return
                    }
                    completion(.success(detailWeather))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

}

extension NetworkManager {

    // MARK: - Parsing functions

    private func parseToSimpleWeather(_ weatherData: Data) -> SimpleWeather? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let cityName = decodedData.name
            let iconName = decodedData.weather[0].icon
            let temperature = Int(decodedData.main.temp)
            let humidity = decodedData.main.humidity
            
            let simpleWeather = SimpleWeather(
                cityName: cityName,
                iconName: iconName,
                currentTemperature: temperature,
                currentHumidity: humidity
            )
            return simpleWeather
        } catch {
            return nil
        }
    }

    private func parseToDetailWeather(_ weatherData: Data) -> DetailWeather? {
        let decoder = JSONDecoder()
        do {
            let decodedWeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            let cityName = decodedWeatherData.name
            let iconName = decodedWeatherData.weather[0].icon
            let currentTemperature = Int(decodedWeatherData.main.temp)
            let feelingTemperature = Int(decodedWeatherData.main.feels_like)
            let currentHumidity = decodedWeatherData.main.humidity
            let minimumTemperature = Int(decodedWeatherData.main.temp_min)
            let maximumTemperature = Int(decodedWeatherData.main.temp_max)
            let airPressure = Int(decodedWeatherData.main.pressure)
            let windSpeed = Int(decodedWeatherData.wind.speed)
            let description = decodedWeatherData.weather[0].description
            
            let detailWeather = DetailWeather(
                cityName: cityName,
                iconName: iconName,
                currentTemperature: currentTemperature,
                feelingTemperature: feelingTemperature,
                currentHumidity: currentHumidity,
                minimumTemperature: minimumTemperature,
                maximumTemperature: maximumTemperature,
                airPressure: airPressure,
                windSpeed: windSpeed,
                description: description
            )
            return detailWeather
        } catch {
            return nil
        }
    }
}
