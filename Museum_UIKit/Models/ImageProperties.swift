//
//  ImageProperties.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 08.04.2023.
//

import UIKit

struct ImageProperties {
    let key: String
    let data: Data
    
    init?(with image: UIImage, forkey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}

