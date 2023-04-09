//
//  ImgurModel.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 08.04.2023.
//

import Foundation

struct ImgurModel: Codable {
    let data: ImgurData
}

struct ImgurData: Codable {
    let link: String
}
