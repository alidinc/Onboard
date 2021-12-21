//
//  JSONValue.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 17/12/2021.
//

import Foundation

struct GeoData: Codable, Hashable {
    let data: [Country]
}

struct Country: Codable, Hashable {
    let name: String
    let capital: String
}
