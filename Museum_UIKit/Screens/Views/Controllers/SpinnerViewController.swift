//
//  SpinnerViewController.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 10.04.2023.
//

import UIKit
import SnapKit

final class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
