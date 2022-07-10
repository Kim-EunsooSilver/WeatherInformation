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

    // MARK: - UI Properties

    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    private let citiesWeatherTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    // MARK: - viewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.loadingView.isLoading = true
        resetSimpleWeathers()
        getSimpleWeatherInformation()
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
    }

    // MARK: - Methods

    private func getSimpleWeatherInformation() {
        let group = DispatchGroup()
        let networkManager = NetworkManager.shared
        var networkError: NetworkManagerError?
        K.cities.forEach { cityName in
            group.enter()
            networkManager.fetchSimpleWeather(cityName: cityName) { [weak self] result in
                switch result {
                    case .success(let _simpleWeather):
                        self?.simpleWeathers.append(_simpleWeather)
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
            self?.simpleWeathers.sort(
                by: { $0.cityName.localized < $1.cityName.localized }
            )
            self?.loadingView.isLoading = false
            self?.citiesWeatherTableView.reloadData()
        }
    }
    
    private func resetSimpleWeathers() {
        simpleWeathers = []
    }
}

// MARK: - UITableViewDataSource

extension CitiesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simpleWeathers.count
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

        return cell
    }
}

// MARK: - UITableViewDelegate

extension CitiesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = WeatherDetailViewController()
        nextVC.cityName = simpleWeathers[indexPath.row].cityName
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
