//
//  UIViewController+Children.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 01.04.2023.
//

import UIKit

extension UIViewController {
  /// Add a child view controller to the current UIViewController. Use this method instead of `addChild`!
  @discardableResult
  func addChildController(_ child: UIViewController?, bottomAnchor: NSLayoutYAxisAnchor? = nil) -> UIViewController? {
    guard let child = child else {
      return nil
    }

    if child.parent != nil {
      child.removeFromParentVC()
    }

    child.willMove(toParent: self)
    addChild(child)
    view.addSubview(child.view)
    child.didMove(toParent: self)

    child.view.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      child.view.topAnchor.constraint(equalTo: view.topAnchor),
      child.view.bottomAnchor.constraint(equalTo: bottomAnchor ?? view.bottomAnchor)
    ])

    return child
  }

  /// Remove this view controller from its parent controller
  @objc func removeFromParentVC() {
    guard parent != nil else {
      return
    }

    DispatchQueue.main.async {
      self.willMove(toParent: nil)
      NSLayoutConstraint.deactivate(self.view.constraints) // clear constraints
      self.view.removeFromSuperview()
      self.removeFromParent()
    }
  }
}

