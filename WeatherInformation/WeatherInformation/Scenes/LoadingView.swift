//
//  LoadingView.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/01.
//

import UIKit

final class LoadingView: UIView {

    // MARK: - Properties

    var isLoading = false {
        didSet {
            self.isHidden = !self.isLoading
            self.isLoading ? self.indicatorView.startAnimating() : self.indicatorView.stopAnimating()
        }
    }

    // MARK: - UI Properties

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        return indicatorView
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setLayout

    private func setLayout() {
        self.addSubview(backgroundView)
        self.addSubview(indicatorView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
