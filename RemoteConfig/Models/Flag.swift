//
//  Flag.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 20/12/2021.
//

import Foundation

struct FlagData: Codable {
    let error: Bool
    let msg: String
    let data: Flag?
}

// MARK: - DataClass
struct Flag: Codable {
    let name: String?
    let flag: String?
    let iso2, iso3: String?
}
