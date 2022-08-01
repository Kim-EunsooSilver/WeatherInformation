//
//  CitiesWeatherListViewController.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/06/24.
//

import UIKit
import CoreLocation

final class CitiesWeatherListViewController: UIViewController {
    
    // MARK: - UIProperties

    private let citiesWeatherListView = CitiesWeatherListView()

    // MARK: - Properties

    private let citiesWeatherListModel = CitiesWeatherListModel()
    private let locationManager = CLLocationManager()

    // MARK: - viewLifeCycle

    override func loadView() {
        super.loadView()
        
        view = citiesWeatherListView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        citiesWeatherListModel.delegate = self
        setLocationManager()
        setTableView()
        getUserLocation()
        
        citiesWeatherListView.loadingView.isLoading = true
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - setTableView

    private func setTableView() {
        let citiesWeatherTableView = citiesWeatherListView.citiesWeatherTableView
        citiesWeatherTableView.delegate = self
        citiesWeatherTableView.dataSource = self
        citiesWeatherTableView.refreshControl?.addTarget(
            self,
            action: #selector(pullToRefresh(_:)),
            for: .valueChanged
        )
    }
    // MARK: - setLocationManager

    private func setLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
    }

    // MARK: - Methods

    private func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @objc private func pullToRefresh(_ sender: UIRefreshControl) {
        getUserLocation()
    }
}

// MARK: - UITableViewDataSource

extension CitiesWeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesWeatherListModel.simpleWeathers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if locationManager.authorizationStatus == .denied {
            return nil
        }
        let dequeuedHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: K.weatherHeaderID)
        guard let header = dequeuedHeader as? WeatherTableViewHeaderView,
              let detailWeather = citiesWeatherListModel.myLocationWeather else {
            return nil
        }
        citiesWeatherListModel.getWeatherIcon(iconName: detailWeather.iconName) { iconImage in
            header.setProperties(detailWeather: detailWeather, weatherIcon: iconImage)
        }
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(
            withIdentifier: K.weatherCellID,
            for: indexPath
        )
        guard let cell = dequeuedCell as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        let simpleWeather = citiesWeatherListModel.simpleWeathers[indexPath.row]
        citiesWeatherListModel.getWeatherIcon(iconName: simpleWeather.iconName) { iconImage in
            cell.setProperties(simpleWeather: simpleWeather, weatherIcon: iconImage)
        }
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CitiesWeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if locationManager.authorizationStatus == .denied {
            return 0
        } else {
            return 200
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = citiesWeatherListModel.simpleWeathers[indexPath.row].cityName

        let nextVC = WeatherDetailViewController()
        nextVC.weatherDetailModel = WeatherDetailModel(cityName: cityName)
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate

extension CitiesWeatherListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            citiesWeatherListModel.setMyLocationInformation(currentLocation: location)
            citiesWeatherListModel.getWeatherData()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension CitiesWeatherListViewController: CitiesWeatherListModelDelegate {
    func didUpdateWeatherData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            let loadingView = self.citiesWeatherListView.loadingView
            let citiesWeatherTableView = self.citiesWeatherListView.citiesWeatherTableView
            
            if loadingView.isLoading == true {
                loadingView.isLoading = false
            }
            if citiesWeatherTableView.refreshControl?.isRefreshing == true {
                citiesWeatherTableView.refreshControl?.endRefreshing()
            }
            
            citiesWeatherTableView.reloadData()
        }
    }
    
    func didFailWithError(error: NetworkManagerError) {
        presentNetworkError(with: error)
    }
}
