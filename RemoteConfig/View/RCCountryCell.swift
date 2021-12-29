//
//  CountryCollectionViewCell.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 19/12/2021.
//

<<<<<<< HEAD
import SnapKit
import UIKit

class RCCountryCell: UICollectionViewCell {

=======
import UIKit

class RCCountryCell: UICollectionViewCell {
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
    // MARK: - Properties
    static let reuseID = R.string.localizable.countryCell()
    private let flagImageView = RCImageView(frame: .zero)
    private let countryLabel = RCLabel(textAlignment: .left, fontSize: 12, weight: .bold)
    private let capitalLabel = RCLabel(textAlignment: .left, fontSize: 10, weight: .medium)
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .equalSpacing
<<<<<<< HEAD
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
=======
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
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
<<<<<<< HEAD
    private func setupViews() {
        addSubview(flagImageView)
        addSubview(stackView)
=======
    private func configure() {
        addSubview(flagImageView)
        addSubview(stackView)
        addSubview(activityIndicator)
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
        stackView.addArrangedSubview(countryLabel)
        stackView.addArrangedSubview(capitalLabel)
        stackView.addShadow(color: .blue)
        backgroundColor = .quaternaryLabel
        layer.masksToBounds = true
        layer.cornerRadius = 20
<<<<<<< HEAD

        let padding: CGFloat = 2
        flagImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(flagImageView.snp_bottomMargin).offset(padding)
            make.leading.trailing.equalToSuperview().offset(padding)
        }
=======
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
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
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
<<<<<<< HEAD
        WebService.shared.downloadImage(from: urlString) { result in
            guard let image = result else { return }
            self.flagImageView.image = image
=======
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            WebService.shared.downloadImage(from: urlString) { result in
                guard let image = result else { return }
                self.flagImageView.image = image
                self.activityIndicator.stopAnimating()
            }
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
        }
    }
    func set(country: Country) {
        self.countryLabel.text = country.name
        self.capitalLabel.text = country.capital
        self.setFlag(for: country)
    }
}
