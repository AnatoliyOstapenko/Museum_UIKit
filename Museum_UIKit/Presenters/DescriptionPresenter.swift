//
//  DescriptionPresenter.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 09.04.2023.
//

import UIKit

// Outside
protocol DescriptionViewProtocol: AnyObject {
    func setSerpapiModel(model: WikiModel)
    func setAlert(with alertItem: AlertItem?)
}
// Inside
protocol DescriptionPresenterProtocol: AnyObject {
    init (view: DescriptionViewProtocol, networkManager: NetworkingManagerProtocol)
    func getStringURL(stringURL: String)
}

class DescriptionPresenter: DescriptionPresenterProtocol {
    weak var view: DescriptionViewProtocol?
    private let networkManager: NetworkingManagerProtocol
    private var alertItem: AlertItem?
    
    required init(view: DescriptionViewProtocol, networkManager: NetworkingManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func getStringURL(stringURL: String) {
        networkManager.getDataFromSerpapi(query: stringURL) { [weak self] result in
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
