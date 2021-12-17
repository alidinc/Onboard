//
//  JSONValue.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 17/12/2021.
//

import Foundation

struct BusinessFlow: Codable {
    let defaultProductIdentifierForBlurView: String
    let shouldBlurPremiumFilterResults,
        showSubscriptionScreenOnBoot,
        freeUsersCanUseFreeFilters,
        protectOrganics,
        shouldShowUserTrackingPermissionViewController: Bool
    let claytoonExecuteLimit: Int
}
