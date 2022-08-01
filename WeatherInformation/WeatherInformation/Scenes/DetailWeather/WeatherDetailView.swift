//
//  WeatherDetailView.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/31.
//

import UIKit

class WeatherDetailView: UIView {
    
    let loadingView: LoadingView = {
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

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setLayout()
    }
    
    private func setLayout() {
        backgroundColor = .systemBackground
        
        let uiProperties = [loadingView, cityNameLabel, descriptionLabel, weatherIcon, labelStackView]
        
        uiProperties.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        uiProperties.forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),

            
            cityNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            cityNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 30),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            weatherIcon.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            weatherIcon.widthAnchor.constraint(equalToConstant: 150),
            weatherIcon.heightAnchor.constraint(equalToConstant: 150),
            weatherIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            labelStackView.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 30),
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setProperties(detailWeather: DetailWeather?, wetherIcon: UIImage) {
        
        guard let _detailWeather = detailWeather else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            let localizedStringFormat = K.LocalizedLabelStringFormat.self
            self.cityNameLabel.text = _detailWeather.cityName.localized
            self.temperatureLabel.text = String(
                format: localizedStringFormat.temperature,
                _detailWeather.currentTemperature
            )
            self.feelingTemperatureLabel.text = String(
                format: localizedStringFormat.feelingTemperature,
                _detailWeather.feelingTemperature
            )
            self.currentHumidityLabel.text = String(
                format: localizedStringFormat.currentHumidity,
                _detailWeather.currentHumidity
            )
            self.minimumTemperatureLabel.text = String(
                format: localizedStringFormat.minimumTemperature,
                _detailWeather.minimumTemperature
            )
            self.maximumTemperatureLabel.text = String(
                format: localizedStringFormat.maximumTemperature,
                _detailWeather.maximumTemperature
            )
            self.airPressureLabel.text = String(
                format: localizedStringFormat.airPressure,
                _detailWeather.airPressure
            )
            self.windSpeedLabel.text = String(
                format: localizedStringFormat.windSpeed,
                _detailWeather.windSpeed
            )
            self.descriptionLabel.text = "\(_detailWeather.description)"
            self.weatherIcon.image = wetherIcon
        }
    }

}
