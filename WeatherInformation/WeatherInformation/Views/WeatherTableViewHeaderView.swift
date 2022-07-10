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
    private lazy var iconAndDescriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherIcon, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var informationStackView: UIStackView = {
        let leftStackView = UIStackView(arrangedSubviews: [temperatureLabel, minimumTemperatureLabel, currentHumidityLabel])
        let rightStackView = UIStackView(arrangedSubviews: [feelingTemperatureLabel, maximumTemperatureLabel, windSpeedLabel])
        
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
}
