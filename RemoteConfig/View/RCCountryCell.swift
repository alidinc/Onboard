//
//  CountryCollectionViewCell.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 19/12/2021.
//

import UIKit

class RCCountryCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseID = R.string.localizable.countryCell()
    private let flagImageView = RCImageView(frame: .zero)
    private let countryLabel = RCLabel(textAlignment: .left, fontSize: 12, weight: .bold)
    private let capitalLabel = RCLabel(textAlignment: .left, fontSize: 10, weight: .medium)
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.axis      = .vertical
        stack.spacing   = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    private func configure() {
        addSubview(flagImageView)
        addSubview(stackView)
        addSubview(activityIndicator)
        stackView.addArrangedSubview(countryLabel)
        stackView.addArrangedSubview(capitalLabel)
        stackView.addShadow(color: .blue)
        backgroundColor = .quaternaryLabel
        layer.masksToBounds = true
        layer.cornerRadius = 20
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: topAnchor),
            flagImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            flagImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            flagImageView.heightAnchor.constraint(equalToConstant: 60),
            activityIndicator.centerXAnchor.constraint(equalTo: flagImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: flagImageView.centerYAnchor),
            stackView.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 2),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2)
        ])
    }
    private func setFlag(for country: Country) {
        WebService.shared.getISO(with: country.name) { [weak self] result in
            switch result {
            case .success(let result):
                if let resultString = result.iso2 {
                   self?.downloadSVGImage(urlString: resultString)
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    private func downloadSVGImage(urlString: String) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            WebService.shared.downloadImage(from: urlString) { result in
                guard let image = result else { return }
                self.flagImageView.image = image
                self.activityIndicator.stopAnimating()
            }
        }
    }
    func set(country: Country) {
        self.countryLabel.text = country.name
        self.capitalLabel.text = country.capital
        self.setFlag(for: country)
    }
}
