//
//  CountryCollectionViewCell.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 19/12/2021.
//

import SevenAppsKit
import SnapKit
import UIKit

class RCCountryCell: UICollectionViewCell {

    // MARK: - Properties
    static let reuseID = R.string.localizable.countryCell()
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(named: "image")!
        imageView.layer.cornerRadius = 22
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.image = .init(named: "image")
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
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
    private var country: Country!

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
            make.top.equalTo(flagImageView.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview().offset(padding)
        }
    }
    
    private func setFlag(for country: Country) {
        WebService.shared.getISO(with: country.name) { [weak self] result in
            if country != self?.country {
                return
            }
            switch result {
            case .success(let result):
                if let resultString = result.iso2 {
                    WebService.shared.downloadImage(from: resultString) { [weak self] result in
                        guard let image = result else { return }
                        DispatchQueue.main.async {
                            self?.flagImageView.image = image
                        }
                    }
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
}

 extension RCCountryCell: SAK.UI.Fillable {
     typealias ObjectType = Country
     
     func prepareForDrawing(with object: Country) {
         countryLabel.text = object.name
         capitalLabel.text = object.capital
         setFlag(for: object)
     }
 }

