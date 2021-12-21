//
//  ViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 16/12/2021.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Properties
    private var rcLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    private var rcSwitch: UISwitch = {
        let rcSwitch = UISwitch()
        rcSwitch.translatesAutoresizingMaskIntoConstraints = false
        return rcSwitch
    }()
    private var rcNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .green
        return label
    }()
    private var rcButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(navigateToCountriesVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tap here to check out capitals ->", for: .normal)
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        RemoteConfigService.shared.fetchRemoteConfig { [weak self] in
            DispatchQueue.main.async {
                self?.fetchValuesFromRemoteConfig()
            }
        }
    }
    // MARK: - Methods
    private func configureView() {
        view.backgroundColor = .gray
        view.addSubview(rcLabel)
        view.addSubview(rcSwitch)
        view.addSubview(rcNumberLabel)
        view.addSubview(rcButton)
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            rcLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            rcLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            rcLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            rcSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rcSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rcButton.topAnchor.constraint(equalTo: rcSwitch.bottomAnchor, constant: padding),
            rcButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            rcButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            rcNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            rcNumberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            rcNumberLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2 * padding)
        ])
    }
    private func fetchValuesFromRemoteConfig() {
        self.rcLabel.text = RemoteConfigService.shared.string(forKey: ValueKey.labelText)
        self.rcSwitch.setOn(RemoteConfigService.shared.bool(forKey: ValueKey.boolCheck), animated: true)
        self.rcNumberLabel.text = String(RemoteConfigService.shared.int(forKey: ValueKey.numberValue))
    }
    // MARK: - Actions
    @objc func navigateToCountriesVC() {
        let countriesVC = CountriesViewController()
        self.navigationController?.pushViewController(countriesVC, animated: true)
    }
}
