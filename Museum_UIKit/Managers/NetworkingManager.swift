//
//  NetworkingManager.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 05.04.2023.
//

import Foundation
import Alamofire

protocol NetworkingManagerProtocol {
    func getDataFromWiki(query: String, completion: @escaping (Result<WikiModel, NetworkingError>)->Void)
    func requestInfo(query: String, completion: @escaping(Result<WikiModel, Error>) -> Void)
}

enum NetworkingError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidTask
    case unableToComplete
}

class NetworkingManager: NetworkingManagerProtocol {
    
    // URLSession version:
    func getDataFromWiki(query: String, completion: @escaping(Result<WikiModel, NetworkingError>)->Void) {
        
        let endpoint = Constants.wikiBaseURL + query

        guard let encodedEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedEndpoint) else {
            print("bad url")
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidTask))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let wikiData = try JSONDecoder().decode(WikiAPIModel.self, from: data)
                guard let pageID = wikiData.query.pageids.first else { return }
                let model = WikiModel(title: wikiData.query.pages[pageID]?.title ?? "",
                                      description: wikiData.query.pages[pageID]?.extract ?? "",
                                      imageURL: wikiData.query.pages[pageID]?.thumbnail.source ?? "")
                completion(.success(model))
                
            } catch {
                completion(.failure(.unableToComplete))
            }
        }
        task.resume()
    }
    
    // Alamofire version
    func requestInfo(query: String, completion: @escaping(Result<WikiModel, Error>) -> Void) {
        
        guard let endpoint = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        let parameters: [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "explaintext" : "",
            "exintro" : "",
            "titles" : endpoint,
            "indexpageids" : "",
            "pithumbsize" : "500"
        ]
        
        AF.request(Constants.wikiEndpoint, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: WikiAPIModel.self) { response in
                switch response.result {
                case .success(let result):
                    guard let pageID = result.query.pageids.first else { return }
                    let model = WikiModel(title: result.query.pages[pageID]?.title ?? "",
                                          description: result.query.pages[pageID]?.extract ?? "",
                                          imageURL: result.query.pages[pageID]?.thumbnail.source ?? "")
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
