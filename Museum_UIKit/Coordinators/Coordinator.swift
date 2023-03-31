//
//  Coordinator.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 31.03.2023.
//

import UIKit

protocol Coordinator {
    var childCoordinator: [Coordinator]? { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
