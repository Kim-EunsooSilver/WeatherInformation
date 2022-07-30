//
//  ViewController.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/06/24.
//

import UIKit
import CoreLocation

final class CitiesWeatherListViewController: UIViewController {

    // MARK: - Properties

    private let citiesWeatherListModel = CitiesWeatherListModel()
    private let locationManager = CLLocationManager()

    // MARK: - UI Properties

    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    private let citiesWeatherTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()

    // MARK: - viewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setTableView()
        setLocationManager()
        getUserLocation()
        self.loadingView.isLoading = true
        
        getSimpleWeatherInformation()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - setLayout

    private func setLayout() {
        view.addSubview(citiesWeatherTableView)
        view.addSubview(loadingView)
        
        citiesWeatherTableView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            citiesWeatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            citiesWeatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            citiesWeatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            citiesWeatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - setTableView

    private func setTableView() {
        citiesWeatherTableView.dataSource = self
        citiesWeatherTableView.delegate = self
        citiesWeatherTableView.register(
            WeatherTableViewCell.self,
            forCellReuseIdentifier: K.weatherCellID
        )
        citiesWeatherTableView.register(
            WeatherTableViewHeaderView.self,
            forHeaderFooterViewReuseIdentifier: K.weatherHeaderID
        )
        citiesWeatherTableView.refreshControl = UIRefreshControl()
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

    private func getSimpleWeatherInformation() {
        citiesWeatherListModel.getSimpleWeatherInformation { [weak self] result in
            switch result {
                case .success():
                    DispatchQueue.main.async {
                        self?.loadingView.isLoading = false
                        self?.citiesWeatherTableView.reloadData()
                    }
                case .failure(let error):
                    self?.presentNetworkError(with: error)
            }
        }
    }
    
    private func getMyLocationWeather() {
        citiesWeatherListModel.getMyLocationWeather { [weak self] result in
            switch result {
                case .success():
                    self?.translateCityName()
                case .failure(let error):
                    self?.presentNetworkError(with: error)
            }
        }
    }

    private func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @objc private func pullToRefresh(_ sender: Any) {
        getUserLocation()
        citiesWeatherListModel.getSimpleWeatherInformation { [weak self] result in
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self?.citiesWeatherTableView.refreshControl?.endRefreshing()
                        self?.citiesWeatherTableView.reloadData()
                    }
                case .failure(let error):
                    self?.presentNetworkError(with: error)
            }
        }
    }

    private func translateCityName() {
        citiesWeatherListModel.translateCityName { [weak self] result in
            switch result {
                case .success():
                    DispatchQueue.main.async {
                        self?.citiesWeatherTableView.reloadData()
                    }
                case .failure(let error):
                    self?.presentNetworkError(with: error)
            }
        }
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
        
        CacheManager.getWeatherIcon(iconName: detailWeather.iconName) { [weak self] iconImage in
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
        CacheManager.getWeatherIcon(iconName: simpleWeather.iconName) { iconImage in
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
        let nextVC = WeatherDetailViewController()
        nextVC.cityName = citiesWeatherListModel.simpleWeathers[indexPath.row].cityName
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate

extension CitiesWeatherListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            citiesWeatherListModel.setMyLocationInformation(currentLocation: location)
            getMyLocationWeather()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
