//
//  WeatherCollectionViewCell.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/18.
//

import UIKit

final class WeatherCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties

    private let cityTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
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
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    // MARK: - setLayout

    private func setLayout() {
        contentView.addSubview(cityTitleLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(humidityLabel)
        
        cityTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cityTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            weatherIcon.topAnchor.constraint(equalTo: cityTitleLabel.bottomAnchor, constant: 5),
            weatherIcon.heightAnchor.constraint(equalToConstant: 100),
            weatherIcon.widthAnchor.constraint(equalToConstant: 100),
            weatherIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 5),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            humidityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 5),
            humidityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.masksToBounds = true
    }
}
