//
//  RemoteConfigService.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 16/12/2021.
//

import Foundation
import Firebase

enum RemoteConfigKey: String {
    case labelText
    case boolCheck
    case numberValue
    case geoData
}

class RemoteConfigService {
    // MARK: - Properties
    private let remoteConfig = RemoteConfig.remoteConfig()
    static let shared = RemoteConfigService()
    private init() {}

    // MARK: - Methods
    func fetchRemoteConfig(completion: @escaping () -> Void) {
        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] (_, error) in
            guard error == nil else { return }
            print("Got the value from Remote Config!")
            self?.remoteConfig.activate()
            completion()
        }
    }

    func setDefaultsForRC(with defaults: [String: Any?]) {
        self.remoteConfig.setDefaults(defaults as? [String: NSObject])
    }

    func bool(forKey key: RemoteConfigKey) -> Bool {
      self.remoteConfig[key.rawValue].boolValue
    }

    func string(forKey key: RemoteConfigKey) -> String {
      self.remoteConfig[key.rawValue].stringValue ?? ""
    }

    func int(forKey key: RemoteConfigKey) -> Int {
      self.remoteConfig[key.rawValue].numberValue.intValue
    }

    func jsonValue<T: Codable>(forKey key: RemoteConfigKey, expecting: T.Type) -> T {
        let dataValue = self.remoteConfig.configValue(forKey: key.rawValue).dataValue
        do {
            return try JSONDecoder().decode(expecting, from: dataValue)
        } catch {
            return Bundle.main.decode(expecting, from: "countries.json")
        }
    }
}
