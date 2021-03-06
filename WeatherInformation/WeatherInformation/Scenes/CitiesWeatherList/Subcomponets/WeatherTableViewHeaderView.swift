//
//  WeatherTableViewHeaderView.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/08.
//

import UIKit

final class WeatherTableViewHeaderView: UITableViewHeaderFooterView {

    // MARK: - UI Properties

    private let myLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let feelingTemperatureLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let minimumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let maximumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let currentHumidityLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let updatedTimeLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    private lazy var iconAndDescriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherIcon, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var informationStackView: UIStackView = {
        let leftStackView = UIStackView(
            arrangedSubviews: [
                temperatureLabel,
                minimumTemperatureLabel,
                currentHumidityLabel
            ]
        )
        let rightStackView = UIStackView(
            arrangedSubviews: [
                feelingTemperatureLabel,
                maximumTemperatureLabel,
                windSpeedLabel
            ]
        )
        
        [leftStackView, rightStackView].forEach { stackView in
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.alignment = .leading
            stackView.distribution = .fill
        }
        
        let informationStackView = UIStackView(arrangedSubviews: [leftStackView, rightStackView])
        informationStackView.axis = .horizontal
        informationStackView.spacing = 5
        informationStackView.alignment = .center
        informationStackView.distribution = .fillEqually
        return informationStackView
    }()

    // MARK: - Initializer

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setLayout
    private func setLayout() {
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(myLocationLabel)
        contentView.addSubview(iconAndDescriptionStackView)
        contentView.addSubview(informationStackView)
        contentView.addSubview(updatedTimeLabel)
        
        myLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        feelingTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minimumTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maximumTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        currentHumidityLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        updatedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        iconAndDescriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myLocationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            myLocationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            myLocationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            
            weatherIcon.widthAnchor.constraint(equalToConstant: 100),
            weatherIcon.heightAnchor.constraint(equalToConstant: 100),
            
            iconAndDescriptionStackView.topAnchor.constraint(equalTo: myLocationLabel.bottomAnchor, constant: 10),
            iconAndDescriptionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconAndDescriptionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            informationStackView.topAnchor.constraint(equalTo: myLocationLabel.bottomAnchor, constant: 10),
            informationStackView.leadingAnchor.constraint(equalTo: iconAndDescriptionStackView.trailingAnchor, constant: 5),
            informationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            updatedTimeLabel.topAnchor.constraint(equalTo: informationStackView.bottomAnchor, constant: 5),
            updatedTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            updatedTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Methods

    func setProperties(detailWeather: DetailWeather?, weatherIcon: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let _detailWeather = detailWeather else {
                return
            }
            let localizedStringFormat = K.LocalizedLabelStringFormat.self
            self?.myLocationLabel.text = String(
                format: localizedStringFormat.myLocation,
                _detailWeather.cityName
            )
            self?.descriptionLabel.text = _detailWeather.description
            self?.weatherIcon.image = weatherIcon
            self?.temperatureLabel.text = String(
                format: localizedStringFormat.temperature,
                _detailWeather.currentTemperature
            )
            self?.feelingTemperatureLabel.text = String(
                format: localizedStringFormat.feelingTemperature,
                _detailWeather.currentTemperature
            )
            self?.currentHumidityLabel.text = String(
                format: localizedStringFormat.currentHumidity,
                _detailWeather.currentHumidity
            )
            self?.minimumTemperatureLabel.text = String(
                format: localizedStringFormat.minimumTemperature,
                _detailWeather.minimumTemperature
            )
            self?.maximumTemperatureLabel.text = String(
                format: localizedStringFormat.maximumTemperature,
                _detailWeather.maximumTemperature
            )
            self?.windSpeedLabel.text = String(
                format: localizedStringFormat.windSpeed,
                _detailWeather.windSpeed
            )
            self?.updatedTimeLabel.text = String(
                format: localizedStringFormat.updatedTime,
                _detailWeather.timeOfData
            )
        }
    }
}
