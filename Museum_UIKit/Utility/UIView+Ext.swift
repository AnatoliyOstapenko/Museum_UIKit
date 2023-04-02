//
//  UIView+Ext.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 01.04.2023.
//

import UIKit

extension UIView {
    func addAllSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
