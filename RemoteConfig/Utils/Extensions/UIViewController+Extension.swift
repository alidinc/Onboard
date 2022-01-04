//
//  UIViewController+Extension.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 21/12/2021.
//

import UIKit

extension UIViewController {
    typealias handler = ((UIAlertAction) -> Void)?
    func presentAlert(title: String, message: String, buttonTitle: String, handler: handler, cancelHandler: handler) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: handler))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler))
        alertVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        alertVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alertVC, animated: true)
    }
}
