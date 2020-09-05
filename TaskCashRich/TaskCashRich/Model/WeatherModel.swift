//
//  WeatherModel.swift
//  TaskCashRich
//
//  Created by xtensibleimac on 05/09/20.
//  Copyright © 2020 Shraddha. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let temperature: Float
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
}

