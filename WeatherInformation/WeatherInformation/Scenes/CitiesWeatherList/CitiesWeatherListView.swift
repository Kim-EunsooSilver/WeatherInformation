//
//  CitiesWeatherListView.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/31.
//

import Foundation
import UIKit

class CitiesWeatherListView: UIView {
    
    let loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()

    let citiesWeatherTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setLayout()
        setCitiesWeatherTableView()
    }
    
    private func setLayout() {
        let uiProperties = [loadingView, citiesWeatherTableView]
        
        uiProperties.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        uiProperties.forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            citiesWeatherTableView.topAnchor.constraint(equalTo: topAnchor),
            citiesWeatherTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            citiesWeatherTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            citiesWeatherTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setCitiesWeatherTableView() {
        citiesWeatherTableView.register(
            WeatherTableViewCell.self,
            forCellReuseIdentifier: K.weatherCellID
        )
        citiesWeatherTableView.register(
            WeatherTableViewHeaderView.self,
            forHeaderFooterViewReuseIdentifier: K.weatherHeaderID
        )
        citiesWeatherTableView.refreshControl = UIRefreshControl()
    }
}
