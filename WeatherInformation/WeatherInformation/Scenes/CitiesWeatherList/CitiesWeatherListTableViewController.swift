//
//  CitiesWeatherListTableViewController.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/06/24.
//

import UIKit
import CoreLocation

final class CitiesWeatherListTableViewController: UITableViewController {

    // MARK: - Properties

    private let citiesWeatherListModel = CitiesWeatherListModel()
    private let locationManager = CLLocationManager()

    // MARK: - UI Properties

    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()

    // MARK: - viewLifeCycle

    override func loadView() {
        tableView = UITableView(frame: .zero, style: .grouped)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setTableView()
        setLocationManager()
        
        citiesWeatherListModel.delegate = self
        
        getUserLocation()
        self.loadingView.isLoading = true
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - setLayout

    private func setLayout() {
        view.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - setTableView

    private func setTableView() {
        tableView.register(
            WeatherTableViewCell.self,
            forCellReuseIdentifier: K.weatherCellID
        )
        tableView.register(
            WeatherTableViewHeaderView.self,
            forHeaderFooterViewReuseIdentifier: K.weatherHeaderID
        )
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(
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

extension CitiesWeatherListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesWeatherListModel.simpleWeathers.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if locationManager.authorizationStatus == .denied {
            return nil
        }
        let dequeuedHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: K.weatherHeaderID)
        guard let header = dequeuedHeader as? WeatherTableViewHeaderView,
              let detailWeather = citiesWeatherListModel.myLocationWeather else {
            return nil
        }
        
        CacheManager.getWeatherIcon(iconName: detailWeather.iconName) { iconImage in
            header.setProperties(detailWeather: detailWeather, weatherIcon: iconImage)
        }
        return header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(
            withIdentifier: K.weatherCellID,
            for: indexPath
        )
        guard let cell = dequeuedCell as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        let simpleWeather = citiesWeatherListModel.simpleWeathers[indexPath.row]
        CacheManager.getWeatherIcon(iconName: simpleWeather.iconName) { iconImage in
            cell.setProperties(simpleWeather: simpleWeather, weatherIcon: iconImage)
        }
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CitiesWeatherListTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if locationManager.authorizationStatus == .denied {
            return 0
        } else {
            return 200
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = citiesWeatherListModel.simpleWeathers[indexPath.row].cityName

        let nextVC = WeatherDetailViewController()
        nextVC.weatherDetailModel = WeatherDetailModel(cityName: cityName)
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate

extension CitiesWeatherListTableViewController: CLLocationManagerDelegate {
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

extension CitiesWeatherListTableViewController: CitiesWeatherListModelDelegate {
    func didUpdateWeatherData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            if self.loadingView.isLoading == true {
                self.loadingView.isLoading = false
            }
            if self.tableView.refreshControl?.isRefreshing == true {
                self.tableView.refreshControl?.endRefreshing()
            }
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: NetworkManagerError) {
        presentNetworkError(with: error)
    }
}
