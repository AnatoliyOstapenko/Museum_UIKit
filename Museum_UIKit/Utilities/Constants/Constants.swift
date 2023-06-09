//
//  Constants.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 05.04.2023.
//

import UIKit

enum Constants {
    static let cameraTitle = "MUSEUM"
    static let cameraSubtitle = "Let's begin"
    static let wikiLogo = UIImageView(image: UIImage(named: "wikiLogo"))
    static let wikiEndpoint = "https://en.wikipedia.org/w/api.php"
    /// delete &exintro= if you need more info from  your query
    static let wikiBaseURL = "https://en.wikipedia.org/w/api.php?action=query&prop=extracts|pageimages&pithumbsize=500&format=json&explaintext=&indexpageids&exintro=&titles="
    
    static let serpapiBaseURL = "https://serpapi.com/search.json?engine=google_lens&key="
    static let imgurBaseURL = "https://api.imgur.com/3/image"
    static let titleText = "No Found"
    static let descriptionText = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
"""
}

enum SFSymbols {
    static let camera = UIImage(systemName: "camera.aperture")
}

enum CustomColor {
    static let brandColor = UIColor(named: "brandColor")
}




