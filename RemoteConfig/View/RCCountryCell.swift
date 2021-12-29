//
//  CountryCollectionViewCell.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 19/12/2021.
//

import SnapKit
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
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    private func setupViews() {
        addSubview(flagImageView)
        addSubview(stackView)
        stackView.addArrangedSubview(countryLabel)
        stackView.addArrangedSubview(capitalLabel)
        stackView.addShadow(color: .blue)
        backgroundColor = .quaternaryLabel
        layer.masksToBounds = true
        layer.cornerRadius = 20

        let padding: CGFloat = 2
        flagImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(flagImageView.snp_bottomMargin).offset(padding)
            make.leading.trailing.equalToSuperview().offset(padding)
        }
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
        WebService.shared.downloadImage(from: urlString) { result in
            guard let image = result else { return }
            self.flagImageView.image = image
        }
    }
    func set(country: Country) {
        self.countryLabel.text = country.name
        self.capitalLabel.text = country.capital
        self.setFlag(for: country)
    }
}
