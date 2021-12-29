//
//  Flag.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 20/12/2021.
//

import Foundation

<<<<<<< HEAD
=======
struct FlagData: Codable {
    let error: Bool
    let msg: String
    let data: Flag?
}

>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
// MARK: - DataClass
struct Flag: Codable {
    let name: String?
    let flag: String?
    let iso2, iso3: String?
}
