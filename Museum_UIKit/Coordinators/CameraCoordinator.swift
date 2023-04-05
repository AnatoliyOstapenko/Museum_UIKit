//
//  CameraCoordinator.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 31.03.2023.
//

import UIKit

protocol CameraCoordinatorProtocol: Coordinator {}

class CameraCoordinator: CameraCoordinatorProtocol {
    var childCoordinator: [Coordinator]?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let view = RecognitionViewController()
        view.coordinator = self
        navigationController.pushViewController(view, animated: true)
    }
    
    
}
