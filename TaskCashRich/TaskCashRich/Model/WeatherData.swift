//
//  WeatherData.swift
//  TaskCashRich
//
//  Created by xtensibleimac on 05/09/20.
//  Copyright © 2020 Shraddha. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Float
}

struct Weather: Codable {
    let description: String
    let id: Int
}
