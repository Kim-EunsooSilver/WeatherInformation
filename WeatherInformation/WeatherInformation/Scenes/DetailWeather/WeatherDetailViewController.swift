//
//  WeatherDetailViewController.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/05.
//

import UIKit

final class WeatherDetailViewController: UIViewController {

    // MARK: - UIProperties

    let weatherDetailView = WeatherDetailView()

    // MARK: - Properties

    var weatherDetailModel: WeatherDetailModel?
    
    // MARK: - viewLifeCycle

    override func loadView() {
        super.loadView()
        
        view = weatherDetailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false

        weatherDetailView.loadingView.isLoading = true
        
        weatherDetailModel?.delegate = self
        weatherDetailModel?.getWeatherData()
    }
}

extension WeatherDetailViewController: WeatherDetailModelDelegate {
    func didUpdateWeatherData() {
        let detailWeather = weatherDetailModel?.detailWeather
        weatherDetailModel?.getWeatherIcon(iconName: detailWeather?.iconName ?? "", completion: { icon in
            self.weatherDetailView.setProperties(detailWeather: detailWeather, wetherIcon: icon)
        })
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.weatherDetailView.loadingView.isLoading = false
        }
    }
    
    func didFailWithError(error: NetworkManagerError) {
        presentNetworkError(with: error)
    }
}
