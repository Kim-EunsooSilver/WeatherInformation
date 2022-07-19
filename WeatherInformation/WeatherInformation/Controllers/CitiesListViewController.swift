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
    private let networkManager = NetworkManager.shared
    private var myLocationWeather: DetailWeather?
    private let locationManager = CLLocationManager()

    // MARK: - UI Properties

    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    private let citiesWeatherCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        return collectionView
    }()

    // MARK: - viewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setCollectionView()
        setLocationManager()
        
        self.loadingView.isLoading = true
        
        getSimpleWeatherInformation { [weak self] in
            self?.loadingView.isLoading = false
            self?.citiesWeatherCollectionView.reloadData()
        }
        getUserLocation()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - setLayout

    private func setLayout() {
        view.addSubview(citiesWeatherCollectionView)
        view.addSubview(loadingView)
        
        citiesWeatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            citiesWeatherCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            citiesWeatherCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            citiesWeatherCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            citiesWeatherCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - setCollectionView

    private func setCollectionView() {
        citiesWeatherCollectionView.dataSource = self
        citiesWeatherCollectionView.delegate = self
        citiesWeatherCollectionView.register(
            WeatherCollectionViewCell.self,
            forCellWithReuseIdentifier: K.weatherCellID
        )
        citiesWeatherCollectionView.register(
            WeatherCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: K.weatherHeaderID
        )
        citiesWeatherCollectionView.refreshControl = UIRefreshControl()
        citiesWeatherCollectionView.refreshControl?.addTarget(
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

    private func getSimpleWeatherInformation(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
        var networkError: NetworkManagerError?
        var fetchedSimpleWeathers: [SimpleWeather] = []
        K.cities.forEach { cityName in
            group.enter()
            networkManager.fetchWeather(.simpleWeather, cityName: cityName) { result in
                switch result {
                    case .success(let simpleWeather):
                        semaphore.wait()
                        guard let _simpleWeather = simpleWeather as? SimpleWeather else {
                            semaphore.signal()
                            group.leave()
                            return
                        }
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
        networkManager.fetchWeather(latitude: latitude, longitude: longitude) { [weak self] result in
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
            self?.citiesWeatherCollectionView.refreshControl?.endRefreshing()
            self?.citiesWeatherCollectionView.reloadData()
        }
    }

    private func translateCityName() {
        guard let translatingCityName = myLocationWeather?.cityName else {
            return
        }
        networkManager.fetchTranslatedText(translatingCityName) { [weak self] result in
            switch result {
                case .success(let cityName):
                    self?.myLocationWeather?.cityName = cityName
                    DispatchQueue.main.async {
                        self?.citiesWeatherCollectionView.reloadData()
                    }
                case .failure(let error):
                    self?.presentNetworkError(with: error)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CitiesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return simpleWeathers.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let dequeuedHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.weatherHeaderID, for: indexPath)
                guard let header = dequeuedHeader as? WeatherCollectionReusableView else {
                    return dequeuedHeader
                }
                header.setProperties(detailWeather: myLocationWeather)
                CacheManager.getWeatherIcon(iconName: myLocationWeather?.iconName ?? "") { iconImage in
                    DispatchQueue.main.async {
                        header.weatherIcon.image = iconImage
                    }
                }
                return header
            default:
                assert(false)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: K.weatherCellID,
            for: indexPath
        )
        guard let cell = dequeuedCell as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
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

// MARK: - UICollectionViewDelegate

extension CitiesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = WeatherDetailViewController()
        nextVC.cityName = simpleWeathers[indexPath.row].cityName
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CitiesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
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
