//
//  RemoteConfigService.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 16/12/2021.
//

import Foundation
import Firebase

class RemoteConfigService {
    
    // MARK: - Properties
    var remoteConfig = RemoteConfig.remoteConfig()
    static let shared = RemoteConfigService()
    
    // MARK: - Methods
    func fetchRemoteConfig(completion: @escaping () -> Void) {
        remoteConfig.fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
            guard error == nil else { return }
            print("Got the value from Remote Config!")
            remoteConfig.activate()
            completion()
        }
    }
    
}
