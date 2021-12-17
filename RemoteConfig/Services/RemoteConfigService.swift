//
//  RemoteConfigService.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 16/12/2021.
//

import Foundation
import Firebase

enum ValueKey: String {
    case label_text
    case boolCheck
    case number_value
    case businessFlow
    
}

class RemoteConfigService {
    
    // MARK: - Properties
    var rc = RemoteConfig.remoteConfig()
    var fetchComplete = false
    var loadingDoneCallback: (() -> Void)?
    static let shared = RemoteConfigService()
    
    
    // MARK: - Methods
    func fetchRemoteConfig(completion: @escaping () -> Void) {
        rc.fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
            guard error == nil else { return }
            print("Got the value from Remote Config!")
            rc.activate()
            completion()
        }
    }
    
    func setDefaultsForRC(with defaults: [String: Any?]) {
        self.rc.setDefaults(defaults as? [String: NSObject])
    }
    
    func bool(forKey key: ValueKey) -> Bool {
      self.rc[key.rawValue].boolValue
    }

    func string(forKey key: ValueKey) -> String {
      self.rc[key.rawValue].stringValue ?? ""
    }

    func int(forKey key: ValueKey) -> Int {
      self.rc[key.rawValue].numberValue.intValue
    }
}
