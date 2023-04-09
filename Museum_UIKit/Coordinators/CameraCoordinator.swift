//
//  CameraCoordinator.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 31.03.2023.
//

import UIKit

protocol CameraCoordinatorProtocol: Coordinator {
    func goToDescription(_ stringURL: String, vc: UIViewController)
}

class CameraCoordinator: CameraCoordinatorProtocol {
    var childCoordinator: [Coordinator]?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let view = RecognitionViewController()
        let manager = NetworkingManager()
        let presenter = CameraPresnter(view: view, manager: manager)
        view.presenter = presenter
        view.coordinator = self
        navigationController.pushViewController(view, animated: true)
    }
    
    func goToDescription(_ stringURL: String, vc: UIViewController) {
        let view = DescriptionViewController(stringURL: stringURL)
        let manager = NetworkingManager()
        let presenter = DescriptionPresenter(view: view, networkManager: manager)
        view.presenter = presenter
        view.coordinator = self
        if let viewController = vc as? RecognitionViewController {
            viewController.present(UINavigationController(rootViewController: view), animated: true)
        }
    }
    
}
