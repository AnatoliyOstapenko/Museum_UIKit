//
//  NetworkingManager.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 05.04.2023.
//

import Foundation
import Alamofire
import UIKit

protocol NetworkingManagerProtocol {
    func getDataFromWiki(query: String, completion: @escaping (Result<WikiModel, NetworkingError>)->Void)
    func requestInfo(query: String, completion: @escaping(Result<WikiModel, Error>) -> Void)
    func downloadImage(imageURL: String, completion: @escaping(UIImage?) -> Void)
    func uploadImage(image: UIImage?, completion: @escaping(Result<String, NetworkingError>) -> Void)
}

enum NetworkingError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidTask
    case unableToComplete
    case invalidImage
}

class NetworkingManager: NetworkingManagerProtocol {
    
//    static let shared = NetworkingManager()
//    private init() {}
        
    // URLSession version:
//    func getDataFromWiki(query: String, completion: @escaping(Result<WikiModel, NetworkingError>)->Void) {
//
//        let endpoint = Constants.wikiBaseURL + query
//
//        guard let encodedEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//              let url = URL(string: encodedEndpoint) else {
//            print("bad url")
//            completion(.failure(.invalidURL))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard error == nil else {
//                completion(.failure(.invalidTask))
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completion(.failure(.invalidResponse))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(.invalidData))
//                return
//            }
//
//            do {
//                let wikiData = try JSONDecoder().decode(WikiAPIModel.self, from: data)
//                guard let pageID = wikiData.query.pageids.first else { return }
//                let model = WikiModel(title: wikiData.query.pages[pageID]?.title ?? "",
//                                      description: wikiData.query.pages[pageID]?.extract ?? "",
//                                      imageURL: wikiData.query.pages[pageID]?.thumbnail.source ?? "")
//                completion(.success(model))
//
//            } catch {
//                completion(.failure(.unableToComplete))
//            }
//        }
//        task.resume()
//    }
    // Get HTTP response from Wikipedia
    
    func getDataFromWiki(query: String, completion: @escaping(Result<WikiModel,NetworkingError>) -> Void) {
        let stringURL = Constants.wikiBaseURL + query
        self.request(stringURL: stringURL, expecting: WikiModel.self, completion: completion)
    }
    
    // Get HTTP response from Serpapi server
    
    func getDataFromSerpapi(query: String, completion: @escaping(Result<WikiModel,NetworkingError>) -> Void) {
        let stringURL = Constants.serpapiBaseURL + Password.serpapiKey + query
        print(stringURL)
        self.request(stringURL: stringURL, expecting: WikiModel.self, completion: completion)
    }

    // Generic GET request method
    
    private func request<T: Decodable>(stringURL: String, expecting: T.Type, completion: @escaping(Result<T, NetworkingError>) -> Void) {
        
        guard let endpoint = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
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
                let data = try JSONDecoder().decode(expecting, from: data)
                completion(.success(data))
            } catch { completion(.failure(.unableToComplete)) }
        }
        task.resume()
    }
    
    // Get image from Wiki
    
    func downloadImage(imageURL: String, completion: @escaping(UIImage?) -> Void) {
        guard let url = URL(string: imageURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data, let image = UIImage(data: data) else { return }
            completion(image)
        }
        task.resume()
    }
    
    // POST photo on Imgur server
    func uploadImage(image: UIImage?, completion: @escaping(Result<String, NetworkingError>) -> Void) {
        /// forkey - key get from https://api.imgur.com/endpoints/image#image-upload
        guard let image = image, let imageProperties = ImageProperties(with: image, forkey: "image") else {
            completion(.failure(.invalidImage))
            return
        }
        
        guard let url = URL(string: Constants.imgurBaseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        /// create headers from https://api.imgur.com/oauth2/addclient
        let httpHeaders = ["Authorization": "Client-ID \(Password.imgurKey)"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders /// pass id authorization
        request.httpBody = imageProperties.data /// pass request body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else { return }
            
            print("Response: \(response.statusCode)")
            
            do {
                let link = try JSONDecoder().decode(ImgurModel.self, from: data)
                completion(.success(link.data.link))
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
