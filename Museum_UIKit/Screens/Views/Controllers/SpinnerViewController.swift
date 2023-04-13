//
//  SpinnerViewController.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 10.04.2023.
//

import UIKit
import SnapKit

class SpinnerViewController: UIViewController {
    
    private var containerView: UIView!

        func spinnerActivated() {
            containerView = UIView(frame: view.bounds)
            view.addSubview(containerView)
            containerView.backgroundColor = .systemBackground
            containerView.alpha = 0
            UIView.animate(withDuration: 0.7) { self.containerView.alpha = 0.5 }

            let activityIndicator = UIActivityIndicatorView(style: .large)
            containerView.addSubview(activityIndicator)
            activityIndicator.color = .label
            
            activityIndicator.snp.makeConstraints { make in
                make.centerX.centerY.equalTo(containerView)
            }
            activityIndicator.startAnimating()
        }
        
        func spinnerDeactivated() {
            DispatchQueue.main.async {
                self.containerView.removeFromSuperview()
                self.containerView = nil
            }
        }
        
}
