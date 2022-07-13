//
//  WeatherTableViewHeaderView.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/08.
//

import UIKit

class WeatherTableViewHeaderView: UITableViewHeaderFooterView {

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
    let weatherIcon: UIImageView = {
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
        informationStackView.distribution = .equalSpacing
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
        contentView.backgroundColor = .systemGroupedBackground
        
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

    func setProperties(detailWeather: DetailWeather?) {
        guard let _detailWeather = detailWeather else {
            return
        }
        myLocationLabel.text = "My Location".localized + "(" + _detailWeather.cityName + ")"
        descriptionLabel.text = _detailWeather.description
        temperatureLabel.text = "current temperature: ".localized + "\(_detailWeather.currentTemperature)˚C"
        feelingTemperatureLabel.text = "feeling temperature: ".localized + "\(_detailWeather.feelingTemperature)˚C"
        currentHumidityLabel.text = "current humidity: ".localized + "\(_detailWeather.currentHumidity)%"
        minimumTemperatureLabel.text = "minimum Temperature: ".localized + "\(_detailWeather.minimumTemperature)˚C"
        maximumTemperatureLabel.text = "maximum Temperature: ".localized + "\(_detailWeather.maximumTemperature)˚C"
        windSpeedLabel.text = "wind speed: ".localized + "\(_detailWeather.windSpeed)m/s"
        updatedTimeLabel.text = "updated time: ".localized + _detailWeather.timeOfData
    }
}
