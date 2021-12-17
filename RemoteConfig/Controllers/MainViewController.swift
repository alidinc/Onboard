//
//  ViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 16/12/2021.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var rcLabel: UILabel!
    @IBOutlet weak var rcSwitch: UISwitch!
    @IBOutlet weak var rcNumberLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRemoteConfigDefaults()
        displayNewValues()
        RemoteConfigService.shared.fetchRemoteConfig {
            self.displayNewValues()
        }
    }
    
    // MARK: - Methods
    private func setupRemoteConfigDefaults() {
        let defaultValue: [String: Any?] = [
            ValueKey.label_text.rawValue : "Hello world!",
            ValueKey.boolCheck.rawValue : "false",
            ValueKey.number_value.rawValue : "1000"]
        
        RemoteConfigService.shared.setDefaultsForRC(with: defaultValue)
    }

    private func displayNewValues() {
        DispatchQueue.main.async {
            self.rcLabel.text = RemoteConfigService.shared.string(forKey: ValueKey.label_text)
            self.rcSwitch.setOn(RemoteConfigService.shared.bool(forKey: ValueKey.boolCheck), animated: true)
            self.rcNumberLabel.text = String(RemoteConfigService.shared.int(forKey: ValueKey.number_value))
        }
    }
    
    // MARK: - Actions
    @IBAction func startButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let businessFlowVC = storyboard.instantiateViewController(withIdentifier: "BusinessFlowViewController") as? BusinessFlowViewController else { return }
        navigationController?.pushViewController(businessFlowVC, animated: true)
    }
}

