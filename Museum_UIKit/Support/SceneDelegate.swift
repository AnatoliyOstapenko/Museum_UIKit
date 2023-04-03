//
//  SceneDelegate.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 31.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let navController = UINavigationController()
    var coordinator: CameraCoordinatorProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
//        coordinator = CameraCoordinator(navigationController: navController)
//        coordinator?.start()
        navController.pushViewController(RecognitionViewController(), animated: true)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}

