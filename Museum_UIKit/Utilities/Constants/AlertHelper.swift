//
//  AlertHelper.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 13.04.2023.
//

import Foundation

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
    
    static let unableToComplete = AlertItem(title: "Image Not Found",
                                            message: "Unable to find your image online, please retake photo or contact the support")
    static let invalidImage = AlertItem(title: "Image Error",
                                        message: "Unable to upload your image at this time, please try again or contact the support")
}
