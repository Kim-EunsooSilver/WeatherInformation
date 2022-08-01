//
//  WeatherDetailView.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/31.
//

import UIKit
import SnapKit

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
            addSubview($0)
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        cityNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(cityNameLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        weatherIcon.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.width.height.equalTo(150)
            $0.centerX.equalToSuperview()
        }
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(weatherIcon.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        uiProperties.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setProperties(detailWeather: DetailWeather?) {
        
        guard let _detailWeather = detailWeather else {
            return
        }
        let localizedStringFormat = K.LocalizedLabelStringFormat.self
        cityNameLabel.text = _detailWeather.cityName.localized
        temperatureLabel.text = String(
            format: localizedStringFormat.temperature,
            _detailWeather.currentTemperature
        )
        feelingTemperatureLabel.text = String(
            format: localizedStringFormat.feelingTemperature,
            _detailWeather.feelingTemperature
        )
        currentHumidityLabel.text = String(
            format: localizedStringFormat.currentHumidity,
            _detailWeather.currentHumidity
        )
        minimumTemperatureLabel.text = String(
            format: localizedStringFormat.minimumTemperature,
            _detailWeather.minimumTemperature
        )
        maximumTemperatureLabel.text = String(
            format: localizedStringFormat.maximumTemperature,
            _detailWeather.maximumTemperature
        )
        airPressureLabel.text = String(
            format: localizedStringFormat.airPressure,
            _detailWeather.airPressure
        )
        windSpeedLabel.text = String(
            format: localizedStringFormat.windSpeed,
            _detailWeather.windSpeed
        )
        descriptionLabel.text = "\(_detailWeather.description)"
        CacheManager.getWeatherIcon(iconName: _detailWeather.iconName) {  [weak self] iconImage in
            DispatchQueue.main.async {
                self?.weatherIcon.image = iconImage
            }
        }
    }

}
