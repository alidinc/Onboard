//
//  ViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 16/12/2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var rcLabel: UILabel!
    @IBOutlet weak var rcSwitch: UISwitch!
    @IBOutlet weak var rcNumberLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRemoteConfigDefaults()
        displayNewValues(for: RemoteConfigService.shared.remoteConfig)
        RemoteConfigService.shared.fetchRemoteConfig {
            self.displayNewValues(for: RemoteConfigService.shared.remoteConfig)
        }
    }
    
    // MARK: - Methods
    func setupRemoteConfigDefaults() {
        let defaultValue = ["label_text" : "Hello world!" as NSObject,
                            "boolCheck" : "false" as NSObject,
                            "number_value" : "1000" as NSObject]
        
        RemoteConfigService.shared.remoteConfig.setDefaults(defaultValue)
    }

    func displayNewValues(for remoteConfig: RemoteConfig) {
        let newLabelText = remoteConfig.configValue(forKey: "label_text").stringValue ?? ""
        rcLabel.text = newLabelText
        
        let newStatus = remoteConfig.configValue(forKey: "boolCheck").boolValue
        rcSwitch.setOn(newStatus, animated: true)
        
        let newNumberText = remoteConfig.configValue(forKey: "number_value").numberValue
        rcNumberLabel.text = String(newNumberText as! Int)
    }
}

