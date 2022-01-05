//
//  BusinessFlowViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 17/12/2021.
//

import UIKit

class CountriesViewController: UIViewController {

    enum Section { case main }

    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<Section, Country>!
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.register(RCCountryCell.self,
                                forCellWithReuseIdentifier: RCCountryCell.reuseID)
        return collectionView
    }()
    private var countries = [Country]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchDataFromRemoteConfig()
        configureDataSource()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDataWithSnapshot(on: countries)
    }
    
    // MARK: - Methods
    private func setupView() {
        view.addSubview(collectionView)
    }
    
    private func fetchDataFromRemoteConfig() {
        self.countries = RemoteConfigService.shared.jsonValue(
            forKey: RemoteConfigKey.geoData,
            expecting: GeoData.self).data
    }
}

// MARK: - UICollectionViewDiffableDataSource
extension CountriesViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Country>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, country) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RCCountryCell.reuseID,
                for: indexPath) as? RCCountryCell else { return UICollectionViewCell() }
                cell.prepareForDrawing(with: self.countries[indexPath.row])
            return cell
        })
    }
    func updateDataWithSnapshot(on countries: [Country]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections([.main])
        snapshot.appendItems(countries)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
