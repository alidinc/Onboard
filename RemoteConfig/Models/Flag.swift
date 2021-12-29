//
//  Flag.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 20/12/2021.
//

import Foundation

// MARK: - DataClass
struct Flag: Codable {
    let name: String?
    let flag: String?
    let iso2, iso3: String?
}
