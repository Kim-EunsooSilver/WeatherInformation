//
//  WeatherDetailViewController.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/05.
//

import UIKit

final class WeatherDetailViewController: UIViewController {
    // MARK: - Properties
    var cityName: String?
    private var detailWeather: DetailWeather?
    private let networkManager = NetworkManager.shared
    
    // MARK: - UI Properties
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private let feelingTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private let currentHumidityLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private let minimumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private let maximumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private let airPressureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                temperatureLabel,
                feelingTemperatureLabel,
                currentHumidityLabel,
                minimumTemperatureLabel,
                maximumTemperatureLabel,
                airPressureLabel,
                windSpeedLabel
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()

    // MARK: - viewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadingView.isLoading = true
        getDetailWeather { [weak self] in
            DispatchQueue.main.async {
                self?.setProperties()
                self?.loadingView.isLoading = false
            }
            
        }
    }
    
    // MARK: - setLayout

    private func setLayout() {
        view.backgroundColor = .white
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        feelingTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        currentHumidityLabel.translatesAutoresizingMaskIntoConstraints = false
        minimumTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maximumTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        airPressureLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loadingView)
        view.addSubview(cityNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(weatherIcon)
        view.addSubview(labelStackView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cityNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 30),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherIcon.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            weatherIcon.widthAnchor.constraint(equalToConstant: 150),
            weatherIcon.heightAnchor.constraint(equalToConstant: 150),
            weatherIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            labelStackView.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 30),
            labelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Methods

    private func getDetailWeather(completion: @escaping () -> Void) {
        guard let cityName = cityName else {
            return
        }
        networkManager.fetchDetailWeather(cityName: cityName) { [weak self] result in
            switch result {
                case .success(let _detailWeather):
                    self?.detailWeather = _detailWeather
                    completion()
                case .failure(let error):
                    self?.presentNetworkError(with: error)
            }
        }
    }
    
    private func setProperties() {
        cityNameLabel.text = cityName
        guard let _detailWeather = detailWeather else {
            return
        }
        temperatureLabel.text = "current temperature: \(_detailWeather.currentTemperature)˚C"
        feelingTemperatureLabel.text = "feeling temperature: \(_detailWeather.feelingTemperature)˚C"
        currentHumidityLabel.text = "current humidity: \(_detailWeather.currentHumidity)%"
        minimumTemperatureLabel.text = "minimum Temperature: \(_detailWeather.minimumTemperature)˚C"
        maximumTemperatureLabel.text = "maximum Temperature: \(_detailWeather.maximumTemperature)˚C"
        airPressureLabel.text = "air pressure: \(_detailWeather.airPressure)hPa"
        windSpeedLabel.text = "wind speed: \(_detailWeather.windSpeed)m/s"
        descriptionLabel.text = "\(_detailWeather.description)"
        CacheManager.getWeatherIcon(iconName: _detailWeather.iconName) {  [weak self] iconImage in
            DispatchQueue.main.async {
                self?.weatherIcon.image = iconImage
            }
        }
    }
}
