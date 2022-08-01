//
//  NetworkManager.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/06/27.
//

import Foundation
import Kingfisher
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()

    private init() { }

    private func performRequest(
        with components: URLComponents,
        completion: @escaping (Result<Data, NetworkManagerError>) -> Void
    ) {
        guard let url = components.url else {
            completion(.failure(.urlError))
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
}

// MARK: - Fetch Methods

extension NetworkManager {
    func fetchWeather(
        _ weatherInformation: WeatherInformation,
        cityName: String,
        completion: @escaping (Result<WeatherVO, NetworkManagerError>) -> Void
    ) {
        let urlComponents = getWeatherURLComponents(cityName: cityName)
        performRequest(with: urlComponents) { [weak self] result in
            switch result {
                case .success(let data):
                    guard let weather = self?.parseToWeather(
                        weatherInformation,
                        fetchedWeather: data
                    ) else {
                        completion(.failure(.parseError))
                        return
                    }
                    completion(.success(weather))
                    break
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    func fetchWeather(
        latitude: String,
        longitude: String,
        completion: @escaping (Result<DetailWeather, NetworkManagerError>) -> Void
    ) {
        let urlComponents = getWeatherURLComponents(latitude: latitude, longitude: longitude)
        performRequest(with: urlComponents) { [weak self] result in
            switch result {
                case .success(let data):
                    guard let weatherVO = self?.parseToWeather(.detailWeather, fetchedWeather: data),
                        let detailWeather = weatherVO as? DetailWeather else {
                        completion(.failure(.parseError))
                        return
                    }
                    completion(.success(detailWeather))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func fetchWeatherIcon(
        iconName: String,
        completion: @escaping (Result<UIImage, NetworkManagerError>) -> Void
    ) {
        let urlComponents = getWeatherIconURLComponents(iconName: iconName)
        guard let url = urlComponents.url else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource) { result in
            switch result {
                case .success(let data):
                    completion(.success(data.image))
                case .failure(_):
                    completion(.failure(.kingFisherError))
            }
        }
    }

    func fetchTranslatedText(
        _ text: String,
        completion: @escaping (Result<String, NetworkManagerError>) -> Void
    ) {
        let targetLanguage = Locale.current.languageCode ?? "en"
        let defaultLanguage = "en"
        if targetLanguage == defaultLanguage {
            return
        }
        let urlComponents = getTranslateURLComponents(
            targetText: text,
            targetLanguageCode: targetLanguage,
            sourceLanguageCode: defaultLanguage
        )
        performRequest(with: urlComponents) { result in
            switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(TranslationData.self, from: data)
                        let translatedText = decodedData.data.translations[0].translatedText
                        completion(.success(translatedText))
                    } catch {
                        completion(.failure(.parseError))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

// MARK: - Parse Methods

private extension NetworkManager {
    func decode (_ data: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(WeatherData.self, from: data)
            return data
        } catch {
            return nil
        }
    }
    
    func parseToWeather(
        _ weatherInformation: WeatherInformation,
        fetchedWeather: Data
    ) -> WeatherVO? {
        var weather: WeatherVO?
        guard let weatherData = decode(fetchedWeather) else {
            return nil
        }
        switch weatherInformation {
            case .simpleWeather:
                weather = parseToSimpleWeather(weatherData)
            case .detailWeather:
                weather = parseToDetailWeather(weatherData)
        }
        return weather
    }

    func parseToSimpleWeather(_ weatherData: WeatherData) -> SimpleWeather {
        let cityName = weatherData.name
        let iconName = weatherData.weather[0].icon
        let temperature = Int(weatherData.main.temp)
        let humidity = weatherData.main.humidity
        
        let simpleWeather = SimpleWeather(
            cityName: cityName,
            iconName: iconName,
            currentTemperature: temperature,
            currentHumidity: humidity
        )
        return simpleWeather
    }

    func parseToDetailWeather(_ weatherData: WeatherData) -> DetailWeather? {
        let cityName = weatherData.name
        let iconName = weatherData.weather[0].icon
        let currentTemperature = Int(weatherData.main.temp)
        let feelingTemperature = Int(weatherData.main.feels_like)
        let currentHumidity = weatherData.main.humidity
        let minimumTemperature = Int(weatherData.main.temp_min)
        let maximumTemperature = Int(weatherData.main.temp_max)
        let airPressure = Int(weatherData.main.pressure)
        let windSpeed = Int(weatherData.wind.speed)
        let description = weatherData.weather[0].description
        let timeOfData: String = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            let timeInterval = TimeInterval(String(weatherData.timeOfData)) ?? 0.0
            let time = Date(timeIntervalSince1970: timeInterval)
            return formatter.string(from: time)
        }()
        
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
            description: description,
            timeOfData: timeOfData
        )
        return detailWeather
    }
}

// MARK: - OpenWeatherAPI

private extension NetworkManager {
    func getWeatherURLComponents(cityName: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.weatherPath
        
        components.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: OpenWeatherAPI.languageCode),
            URLQueryItem(name: "appid", value: OpenWeatherAPI.apiKey)
        ]
        return components
    }
    
    func getWeatherURLComponents(latitude: String, longitude: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.weatherPath
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: latitude),
            URLQueryItem(name: "lon", value: longitude),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: OpenWeatherAPI.languageCode),
            URLQueryItem(name: "appid", value: OpenWeatherAPI.apiKey)
        ]
        return components
    }
    
    func getWeatherIconURLComponents(iconName: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = "openweathermap.org"
        components.path = String(format: OpenWeatherAPI.iconPath, iconName)
        return components
    }
}

// MARK: - GoogleTransitionAPI

private extension NetworkManager {
    func getTranslateURLComponents(
        targetText: String,
        targetLanguageCode: String,
        sourceLanguageCode: String
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = GoogleTransitionAPI.scheme
        components.host = GoogleTransitionAPI.host
        components.path = GoogleTransitionAPI.path
        
        components.queryItems = [
            URLQueryItem(name: "key", value: GoogleTransitionAPI.apiKey),
            URLQueryItem(name: "q", value: targetText),
            URLQueryItem(name: "target", value: targetLanguageCode),
            URLQueryItem(name: "source", value: sourceLanguageCode)
        ]
        return components
    }
}
