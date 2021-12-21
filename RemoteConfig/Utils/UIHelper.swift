//
//  CollectionViewFlowLayout.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 19/12/2021.
//

import UIKit

struct UIHelper {
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let columns: CGFloat            = 3
        let padding: CGFloat            = 10
        let width                       = view.bounds.width
        let availableWidth              = width - (4 * padding)
        let itemWidth                   = availableWidth / columns
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.scrollDirection      = .vertical
        flowLayout.sectionInset         = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth)
        return flowLayout
    }
}
