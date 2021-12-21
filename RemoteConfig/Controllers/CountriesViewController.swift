//
//  BusinessFlowViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 17/12/2021.
//

import UIKit

enum Section { case main }

class CountriesViewController: UIViewController {

    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<Section, Country>!
    private var collectionView: UICollectionView!
    private var countries = [Country]()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionVC()
        fetchDataFromRemoteConfig()
        configureDataSource()
    }
    // MARK: - Methods
    private func configureCollectionVC() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.register(RCCountryCell.self, forCellWithReuseIdentifier: RCCountryCell.reuseID)
        view.addSubview(collectionView)
    }
    private func fetchDataFromRemoteConfig() {
        let dataValue = RemoteConfigService.shared.remoteConfig.configValue(forKey: ValueKey.geoData.rawValue).dataValue
        do {
            let result = try JSONDecoder().decode(GeoData.self, from: dataValue)
            self.countries = result.data
        } catch {
            let result = Bundle.main.decode(GeoData.self, from: "countries.json")
            self.countries = result.data
        }
        updateDataWithSnapshot(on: countries)
    }
}

// MARK: - UICollectionViewDiffableDataSource
extension CountriesViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Country>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, country) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RCCountryCell.reuseID, for: indexPath) as? RCCountryCell else { return UICollectionViewCell() }
            cell.set(country: self.countries[indexPath.row])
            return cell
        })
    }
    func updateDataWithSnapshot(on countries: [Country]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections([.main])
        snapshot.appendItems(countries)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
