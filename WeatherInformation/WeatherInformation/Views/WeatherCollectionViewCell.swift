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
}
