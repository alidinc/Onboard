//
//  ViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 16/12/2021.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var rcLabel: UILabel!
    @IBOutlet weak var rcSwitch: UISwitch!
    @IBOutlet weak var rcNumberLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRemoteConfigDefaults()
        displayNewValues()
        fetchRemoteConfig()
    }
    
    // MARK: - Methods
    func setupRemoteConfigDefaults() {
        let defaultValue = ["label_text" : "Hello world!" as NSObject]
        remoteConfig.setDefaults(defaultValue)
        
        let defaultValueBool = ["boolCheck" : "false" as NSObject]
        remoteConfig.setDefaults(defaultValueBool)
        
        let defaultValueNumber = ["number_value" : "1000" as NSObject]
        remoteConfig.setDefaults(defaultValueNumber)
    }

    func displayNewValues() {
        let newLabelText = remoteConfig.configValue(forKey: "label_text").stringValue ?? ""
        rcLabel.text = newLabelText
        
        let newStatus = remoteConfig.configValue(forKey: "boolCheck").boolValue
        rcSwitch.setOn(newStatus, animated: true)
        
        let newNumberText = remoteConfig.configValue(forKey: "number_value").numberValue
        rcNumberLabel.text = String(newNumberText as! Int)
    }
    
    func fetchRemoteConfig() {
        remoteConfig.fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
            guard error == nil else { return }
            print("Got the value from Remote Config!")
            remoteConfig.activate()
            self.displayNewValues()
        }
    }
}

