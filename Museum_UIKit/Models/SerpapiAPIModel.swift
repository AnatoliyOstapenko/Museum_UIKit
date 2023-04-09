//
//  SerpapiAPIModel.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 09.04.2023.
//

import Foundation

struct SerpapiAPIModel: Decodable {
    let request: [SerpapiRequest]
    
    enum CodingKeys: String, CodingKey {
        case request = "knowledge_graph"
    }
}

struct SerpapiRequest: Decodable {
    let title: String
    let subtitle: String?
    let link: String
    let images: [SerpapiImages]
}

struct SerpapiImages: Decodable {
    let stringURL: String?
    
    enum CodingKeys: String, CodingKey {
        case stringURL = "link"
    }
}
