//
//  WikiImagePresenter.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 06.04.2023.
//

import UIKit

protocol WikiImageViewProtocol: AnyObject {
    func setImage(image: UIImage)
}

protocol WikiImagePresenterProtocol: AnyObject {
    init (view: WikiImageViewProtocol, networkManager: NetworkingManagerProtocol)
    func getImage(imageString: String)
}

class WikiImagePresenter: WikiImagePresenterProtocol {
    weak var view: WikiImageViewProtocol?
    private let networkManager: NetworkingManagerProtocol
    
    required init(view: WikiImageViewProtocol, networkManager: NetworkingManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func getImage(imageString: String) {
        networkManager.downloadImage(imageURL: imageString) { [weak self] image in
            guard let self = self, let image = image else { return }
            DispatchQueue.main.async {
                self.view?.setImage(image: image)
            }
        }
    }
}
