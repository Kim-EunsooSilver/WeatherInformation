//
//  CitiesWeatherListView.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/31.
//

import Foundation
import UIKit
import SnapKit

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
            addSubview($0)
        }
        
        loadingView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        citiesWeatherTableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
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
