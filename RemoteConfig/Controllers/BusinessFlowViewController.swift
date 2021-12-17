//
//  BusinessFlowViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 17/12/2021.
//

import UIKit

class BusinessFlowViewController: UIViewController {

    // MARK: - Properties
    var fetchComplete = false
    
    // MARK: - Outlets
    @IBOutlet weak var jsonValueLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRemoteConfigDefaults()
    }
    
    // MARK: - Methods
    private func setupRemoteConfigDefaults() {
        let defaultValue: [String: Any?] = [ValueKey.businessFlow.rawValue : fetchDefaultsFromBundle]
        RemoteConfigService.shared.setDefaultsForRC(with: defaultValue)
        displayDefaultValues()
    }
    
    private func fetchDefaultsFromBundle() -> BusinessFlow? {
        return Bundle.main.decode(BusinessFlow.self, from: "businessFlow.json")
    }
    
    private func displayDefaultValues() {
        DispatchQueue.main.async {
            self.jsonValueLabel.text = self.fetchDataFromRC()?.defaultProductIdentifierForBlurView
        }
    }
    
    private func fetchDataFromRC() -> BusinessFlow? {
        let dataValue = RemoteConfigService.shared.rc.configValue(forKey: ValueKey.businessFlow.rawValue).dataValue
        do {
            return try JSONDecoder().decode(BusinessFlow.self, from: dataValue)
        } catch (let error) {
            fatalError("Unable to fetch data with an error:\(error.localizedDescription)")
        }
    }
}
