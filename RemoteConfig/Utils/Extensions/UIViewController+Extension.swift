//
//  UIViewController+Extension.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 21/12/2021.
//

<<<<<<< HEAD
=======
import Foundation
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String, buttonTitle: String) {
<<<<<<< HEAD
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        alertVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alertVC, animated: true)
=======
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            alertVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(alertVC, animated: true)
        }
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
    }
}
