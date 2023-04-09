//
//  CameraPresnter.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 05.04.2023.
//

import UIKit

// Output
protocol CameraViewProtocol: AnyObject {
    func setWikiData(with data: WikiModel)
    func setLink(with stringURL: String)
    func setAlert(with alertItem: AlertItem?)
}
// Input
protocol CameraPresnterProtocol: AnyObject {
    init (view: CameraViewProtocol, manager: NetworkingManagerProtocol)
    func getWikiData(query: String)
    func fetchLink(image: UIImage?)
}

class CameraPresnter: CameraPresnterProtocol {
    weak var view: CameraViewProtocol?
    private let manager: NetworkingManagerProtocol
    private var alertItem: AlertItem?
    
    required init(view: CameraViewProtocol, manager: NetworkingManagerProtocol) {
        self.view = view
        self.manager = manager
    }
    
    func getWikiData(query: String) {
        manager.getDataFromWiki(query: query) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.view?.setWikiData(with: success)
                case .failure(let failure):
                    self.handlingError(error: failure)
                }
            }
        }

        // Alamofire request
        
        //        manager.requestInfo(query: query) { [weak self] result in
        //            guard let self = self else { return }
        //            DispatchQueue.main.async {
        //                switch result {
        //                case .success(let data):
        //                    self.view?.setWikiData(with: data)
        //                case .failure(let error):
        //                    print("error: \(error)")
        //                }
        //            }
        //        }
    }
    
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
