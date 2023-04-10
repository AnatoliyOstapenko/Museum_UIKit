//
//  CameraPresnter.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 05.04.2023.
//

import UIKit

// Output
protocol CameraViewProtocol: AnyObject {
    func setLink(with stringURL: String)
    func setAlert(with alertItem: AlertItem?)
    func setSerpapiModel(model: WikiModel)
}
// Input
protocol CameraPresnterProtocol: AnyObject {
    init (view: CameraViewProtocol, manager: NetworkingManagerProtocol)
    func fetchLink(image: UIImage?)
    func getStringURL(stringURL: String)
}

class CameraPresnter: CameraPresnterProtocol {
    weak var view: CameraViewProtocol?
    private let manager: NetworkingManagerProtocol
    private var alertItem: AlertItem?
    
    required init(view: CameraViewProtocol, manager: NetworkingManagerProtocol) {
        self.view = view
        self.manager = manager
    }
    
    // Get information from Serpari server

    func getStringURL(stringURL: String) {
        manager.getDataFromSerpapi(query: stringURL) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    
                    let wikiModel = WikiModel(title: success.request[0].title,
                                              description: success.request[0].subtitle ?? "",
                                              imageURL: success.request[0].images[0].stringURL ?? "",
                                              link: success.request[0].link)
                    
                    
                    self.view?.setSerpapiModel(model: wikiModel)
                case .failure(let error):
                    self.handlingError(error: error)
                }
            }
        }
    }
    
    // Upload image on Imgur and get direct link of picture
    
    func fetchLink(image: UIImage?) {
        manager.uploadImage(image: image) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let stringURL):
                    self.view?.setLink(with: stringURL)
                case .failure(let error):
                    self.handlingError(error: error)
                }
            }
        }
    }
    // Handling errors
    private func handlingError(error: NetworkingError) {
        switch error {
        case .invalidURL: self.alertItem = AlertContext.invalidURL
        case .invalidResponse: self.alertItem = AlertContext.invalidResponse
        case .invalidData: self.alertItem = AlertContext.invalidData
        case .invalidTask: self.alertItem = AlertContext.invalidTask
        case .unableToComplete: self.alertItem = AlertContext.unableToComplete
        case .invalidImage: self.alertItem = AlertContext.invalidImage
        }
        self.view?.setAlert(with: self.alertItem)
    }
}
