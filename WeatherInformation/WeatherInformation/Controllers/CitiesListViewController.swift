//
//  ViewController.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/06/24.
//

import UIKit
import CoreLocation

final class CitiesListViewController: UIViewController {

    // MARK: - Properties

    private var simpleWeathers: [SimpleWeather] = []
    private var myLocationWeather: DetailWeather?
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
        
        self.loadingView.isLoading = true
        
        getSimpleWeatherInformation { [weak self] in
            self?.loadingView.isLoading = false
            self?.citiesWeatherTableView.reloadData()
        }
        getUserLocation()
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
        citiesWeatherTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    
    // MARK: - setLocationManager

    private func setLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
    }

    // MARK: - Methods

    private func getSimpleWeatherInformation(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
        let networkManager = NetworkManager.shared
        var networkError: NetworkManagerError?
        var fetchedSimpleWeathers: [SimpleWeather] = []
        K.cities.forEach { cityName in
            group.enter()
            networkManager.fetchSimpleWeather(cityName: cityName) { result in
                switch result {
                    case .success(let _simpleWeather):
                        semaphore.wait()
                        fetchedSimpleWeathers.append(_simpleWeather)
                        semaphore.signal()
                        group.leave()
                    case .failure(let error):
                        networkError = error
                        group.leave()
                        return
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            if networkError != nil {
                self?.presentNetworkError(with: networkError)
            }
            self?.simpleWeathers = fetchedSimpleWeathers.sorted(
                by: { $0.cityName.localized < $1.cityName.localized }
            )
            completion()
        }
    }
    
    private func getMyLocationWeather(location: CLLocation) {
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        NetworkManager.shared.fetchDetailWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
                case .success(let detailWeather):
                    self?.myLocationWeather = detailWeather
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
        getSimpleWeatherInformation { [weak self] in
            self?.citiesWeatherTableView.refreshControl?.endRefreshing()
            self?.citiesWeatherTableView.reloadData()
        }
    }
    
    private func translateCityName() {
        guard let translatingCityName = myLocationWeather?.cityName else {
            return
        }
        NetworkManager.shared.fetchTranslatedText(translatingCityName) { [weak self] result in
            switch result {
                case .success(let cityName):
                    self?.myLocationWeather?.cityName = cityName
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

extension CitiesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simpleWeathers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if locationManager.authorizationStatus == .denied {
            return nil
        }
        let dequeuedHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: K.weatherHeaderID)
        guard let header = dequeuedHeader as? WeatherTableViewHeaderView,
              let detailWeather = myLocationWeather else {
            return nil
        }
        header.setProperties(detailWeather: myLocationWeather)
        CacheManager.getWeatherIcon(iconName: detailWeather.iconName) { iconImage in
            DispatchQueue.main.async {
                header.weatherIcon.image = iconImage
            }
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
        let simpleWeather = simpleWeathers[indexPath.row]
        
        cell.setProperties(simpleWeather: simpleWeather)
        CacheManager.getWeatherIcon(iconName: simpleWeather.iconName) { iconImage in
            DispatchQueue.main.async {
                cell.weatherIcon.image = iconImage
            }
        }
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CitiesListViewController: UITableViewDelegate {
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
        nextVC.cityName = simpleWeathers[indexPath.row].cityName
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}

// MARK: - CLLocationManagerDelegate

extension CitiesListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            getMyLocationWeather(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
