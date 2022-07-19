//
//  WeatherTableViewCell.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/06/24.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {

    // MARK: - UI Properties

    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let cityTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        return label
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var informationStackView: UIStackView = {
        let descriptionStackView = UIStackView(arrangedSubviews: [temperatureLabel, humidityLabel])
        descriptionStackView.axis = .horizontal
        descriptionStackView.alignment = .fill
        descriptionStackView.distribution = .fillEqually
        descriptionStackView.spacing = 5
        
        let informationStackView = UIStackView(
            arrangedSubviews: [
                cityTitleLabel,
                descriptionStackView
            ]
        )
        informationStackView.axis = .vertical
        informationStackView.alignment = .fill
        informationStackView.distribution = .fillEqually
        informationStackView.spacing = 5
        return informationStackView
    }()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func prepareForReuse() {
        super.prepareForReuse()
        weatherIcon.image = nil
    }
    func setProperties(simpleWeather: SimpleWeather?, weatherIcon: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let _simpleWeather = simpleWeather else {
                return
            }
            self?.weatherIcon.image = weatherIcon
            self?.cityTitleLabel.text = _simpleWeather.cityName.localized
            self?.temperatureLabel.text = "Temperature: ".localized + String(_simpleWeather.currentTemperature) + "˚C"
            self?.humidityLabel.text = "Humidity: ".localized + String(_simpleWeather.currentHumidity) + "%"
        }
    }

    // MARK: - setLayout

    private func setLayout() {
        contentView.addSubview(weatherIcon)
        contentView.addSubview(informationStackView)
        
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor),
            weatherIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            weatherIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            weatherIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            informationStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            informationStackView.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 10),
            informationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            informationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
