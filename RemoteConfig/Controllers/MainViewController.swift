//
//  ViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 16/12/2021.
//

<<<<<<< HEAD
import SnapKit
=======
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
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
    private lazy var rcButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(navigateToCountriesVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(R.string.localizable.tapHereToSeeCapitals(), for: .normal)
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        setupView()
=======
        configureView()
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
        RemoteConfigService.shared.fetchRemoteConfig { [weak self] in
            DispatchQueue.main.async {
                self?.fetchValuesFromRemoteConfig()
            }
        }
    }
    // MARK: - Methods
<<<<<<< HEAD
    private func setupView() {
=======
    private func configureView() {
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
        view.backgroundColor = .gray
        view.addSubview(rcLabel)
        view.addSubview(rcSwitch)
        view.addSubview(rcNumberLabel)
        view.addSubview(rcButton)
        let padding: CGFloat = 20
<<<<<<< HEAD

        rcLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2 * padding)
            make.leading.trailing.equalToSuperview().offset(padding)
        }
        rcSwitch.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        rcButton.snp.makeConstraints { make in
            make.top.equalTo(rcSwitch.snp_bottomMargin).offset(padding)
            make.leading.trailing.equalToSuperview().offset(padding)
        }
        rcNumberLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview().offset(-2 * padding)
        }
=======
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
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
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
