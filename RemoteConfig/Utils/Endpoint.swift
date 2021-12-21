//
//  Endpoint.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 17/12/2021.
//

import Foundation

struct Endpoint {
    let scheme: Scheme
    let host: String
    let path: String
    let queryItems: [URLQueryItem]
    var url: URL? {
        var components = URLComponents()
        components.scheme = "\(scheme)"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

enum Scheme: String {
    case http
    case https
}
