//
//  WeatherDetailViewController.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/05.
//

import UIKit

final class WeatherDetailViewController: UIViewController {
    // MARK: - Properties

    var weatherDetailModel: WeatherDetailModel?
    
    // MARK: - viewLifeCycle

    override func loadView() {
        super.loadView()
        
        view = WeatherDetailView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        guard let detailWeatherView = view as? WeatherDetailView else {
            return
        }
        detailWeatherView.loadingView.isLoading = true
        
        weatherDetailModel?.delegate = self
        weatherDetailModel?.getWeatherData()
    }

    // MARK: - setLayout

}

extension WeatherDetailViewController: WeatherDetailModelDelegate {
    func didUpdateWeatherData() {
        let detailWeather = weatherDetailModel?.detailWeather
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            guard let view = self.view as? WeatherDetailView else {
                return
            }
            view.setProperties(detailWeather: detailWeather)
            view.loadingView.isLoading = false
        }
    }
    
    func didFailWithError(error: NetworkManagerError) {
        presentNetworkError(with: error)
    }
    
    
}
