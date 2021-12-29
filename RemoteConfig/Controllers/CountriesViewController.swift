//
//  BusinessFlowViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 17/12/2021.
//

import UIKit

<<<<<<< HEAD
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
=======
enum Section { case main }

class CountriesViewController: UIViewController {

    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<Section, Country>!
    private var collectionView: UICollectionView!
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
    private var countries = [Country]()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
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
            forKey: ValueKey.geoData,
            expecting: GeoData.self).data
=======
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
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
    }
}

// MARK: - UICollectionViewDiffableDataSource
extension CountriesViewController {
    func configureDataSource() {
<<<<<<< HEAD
        dataSource = UICollectionViewDiffableDataSource<Section, Country>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, country) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RCCountryCell.reuseID,
                for: indexPath) as? RCCountryCell else { return UICollectionViewCell() }
=======
        dataSource = UICollectionViewDiffableDataSource<Section, Country>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, country) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RCCountryCell.reuseID, for: indexPath) as? RCCountryCell else { return UICollectionViewCell() }
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
            cell.set(country: self.countries[indexPath.row])
            return cell
        })
    }
    func updateDataWithSnapshot(on countries: [Country]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections([.main])
        snapshot.appendItems(countries)
<<<<<<< HEAD
        self.dataSource.apply(snapshot, animatingDifferences: true)
=======
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
    }
}
