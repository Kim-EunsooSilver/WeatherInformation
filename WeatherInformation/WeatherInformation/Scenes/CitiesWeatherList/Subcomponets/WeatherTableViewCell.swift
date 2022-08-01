//
//  WeatherTableViewCell.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/06/24.
//

import UIKit
import SnapKit

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
            self?.temperatureLabel.text = String(
                format: K.LocalizedLabelStringFormat.temperature,
                _simpleWeather.currentHumidity
            )
            self?.humidityLabel.text = String(
                format: K.LocalizedLabelStringFormat.humidity,
                _simpleWeather.currentHumidity
            )
        }
    }

    // MARK: - setLayout

    private func setLayout() {
        contentView.addSubview(weatherIcon)
        contentView.addSubview(informationStackView)
        
        weatherIcon.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(weatherIcon.snp.height)
            
        }
        informationStackView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(10)
            $0.leading.equalTo(weatherIcon.snp_trailingMargin).offset(10)
        }
    }
}
