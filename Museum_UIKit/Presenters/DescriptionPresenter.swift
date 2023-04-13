//
//  DescriptionPresenter.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 09.04.2023.
//

import UIKit

// Outside
protocol DescriptionViewProtocol: AnyObject {
    func setWikiModel(model: WikiModel)
    func setAlert(with alertItem: AlertItem?)
}
// Inside
protocol DescriptionPresenterProtocol: AnyObject {
    init (view: DescriptionViewProtocol, networkManager: NetworkingManagerProtocol)
    func queryWikiData(query: String)
}

class DescriptionPresenter: DescriptionPresenterProtocol {
    weak var view: DescriptionViewProtocol?
    private let networkManager: NetworkingManagerProtocol
    private var alertItem: AlertItem?
    
    required init(view: DescriptionViewProtocol, networkManager: NetworkingManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
    }
    
    // Get Wiki information by title from Serpapi
    
    func queryWikiData(query: String) {
        networkManager.getDataFromWiki(query: query) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    guard let pageID = success.query.pageids.first else { return }
                    let model = WikiModel(title: success.query.pages[pageID]?.title ?? "",
                                          description: success.query.pages[pageID]?.extract ?? "",
                                          imageURL: success.query.pages[pageID]?.thumbnail.source ?? "")
                    self.view?.setWikiModel(model: model)
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
