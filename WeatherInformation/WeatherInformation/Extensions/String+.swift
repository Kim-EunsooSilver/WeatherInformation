//
//  String+.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/08.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}
