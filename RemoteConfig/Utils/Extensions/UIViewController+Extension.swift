//
//  UIViewController+Extension.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 21/12/2021.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        alertVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alertVC, animated: true)
    }
}
