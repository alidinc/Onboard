//
//  UIView+Extension.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 20/12/2021.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
    }
}
