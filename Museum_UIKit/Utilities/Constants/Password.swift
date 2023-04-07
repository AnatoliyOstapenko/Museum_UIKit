//
//  Password.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 07.04.2023.
//

import Foundation
// try
enum Password {
    
    static let wikiEndpoint = "https://en.wikipedia.org/w/api.php"
    /// delete &exintro= if you need more info from  your query
    static let wikiBaseURL = "https://en.wikipedia.org/w/api.php?action=query&prop=extracts|pageimages&pithumbsize=500&format=json&explaintext=&indexpageids&exintro=&titles="
}
