//
//  Constants.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 05.04.2023.
//

import Foundation

enum Constants {
    
    static let wikiEndpoint = "https://en.wikipedia.org/w/api.php"
    /// delete &exintro= if you need more info from  your query
    static let wikiBaseURL = "https://en.wikipedia.org/w/api.php?action=query&prop=extracts|pageimages&pithumbsize=500&format=json&explaintext=&indexpageids&exintro=&titles="
    
    static let serpapiBaseURL = "https://serpapi.com/search.json?engine=google_lens&key=😎&url=https://www.vangoghstudio.com/Files/6/102000/102147/PageHomeSlideShows/w1170_900501_en.jpg"
    
    static let imgurBaseURL = "https://api.imgur.com/endpoints/image#image-upload"
}

struct AlertItem {
    let title: String
    let message: String
}


struct AlertContext {
    static let invalidURL = AlertItem(title: "Server Error",
                                      message: "There was an issue with connecting to the server, please try again later or contact the support")
                                    
    static let invalidResponse = AlertItem(title: "Server Error",
                                           message: "Invalid response from server, please try again later or contact the support")
                                          
    static let invalidData = AlertItem(title: "Server Error",
                                       message: "The data received from the server is invalid. Please contact the support")

    static let invalidTask = AlertItem(title: "Server Error",
                                       message: "Session unable to complete, there was an issue with connecting to the server, please try again later or contact the support")
    
    static let unableToComplete = AlertItem(title: "Server Error",
                                            message: "Unable to complete your request at this time, please try again later or contact the support")
}
