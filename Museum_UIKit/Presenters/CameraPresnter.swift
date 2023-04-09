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
    func setErorrs(with errors: NetworkingError)
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
                    self.view?.setErorrs(with: failure)
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
                    self.view?.setErorrs(with: error)
                }
            }
        }
    }
}
