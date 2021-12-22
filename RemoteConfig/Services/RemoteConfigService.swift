//
//  RemoteConfigService.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 16/12/2021.
//

import Foundation
import Firebase

enum ValueKey: String {
    case labelText
    case boolCheck
    case numberValue
    case geoData
}

class RemoteConfigService {
    // MARK: - Properties
    var remoteConfig = RemoteConfig.remoteConfig()
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
    func bool(forKey key: ValueKey) -> Bool {
      self.remoteConfig[key.rawValue].boolValue
    }

    func string(forKey key: ValueKey) -> String {
      self.remoteConfig[key.rawValue].stringValue ?? ""
    }

    func int(forKey key: ValueKey) -> Int {
      self.remoteConfig[key.rawValue].numberValue.intValue
    }
}
