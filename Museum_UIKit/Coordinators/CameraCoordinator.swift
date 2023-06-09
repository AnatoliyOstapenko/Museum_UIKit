//
//  CameraCoordinator.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 31.03.2023.
//

import UIKit

protocol CameraCoordinatorProtocol: Coordinator {
    func goToDescription(_ model: SerpapiModel, vc: UIViewController)
}

class CameraCoordinator: CameraCoordinatorProtocol {
    var childCoordinator: [Coordinator]?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let view = CameraViewController()
        let manager = NetworkingManager()
        let presenter = CameraPresnter(view: view, manager: manager)
        view.presenter = presenter
        view.coordinator = self
        navigationController.pushViewController(view, animated: true)
    }
    
    func goToDescription(_ model: SerpapiModel, vc: UIViewController) {
        let view = DescriptionViewController(model: model)
        let manager = NetworkingManager()
        let presenter = DescriptionPresenter(view: view, networkManager: manager)
        view.presenter = presenter
        view.coordinator = self
        if let viewController = vc as? CameraViewController {
            viewController.present(UINavigationController(rootViewController: view), animated: true)
        }
    }
    
}
