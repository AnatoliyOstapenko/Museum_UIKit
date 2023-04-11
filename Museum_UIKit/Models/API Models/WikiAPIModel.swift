//
//  WikiAPIModel.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 05.04.2023.
//

import Foundation

struct WikiAPIModel: Decodable {
    let query: WikiQuery
}

struct WikiQuery: Decodable {
    let pageids: [String]
    let pages: [String: WikiPage]
}

struct WikiPage: Decodable {
    let title: String
    let extract: String
    let thumbnail: WikiSource
}

struct WikiSource: Decodable {
    let source: String
}

