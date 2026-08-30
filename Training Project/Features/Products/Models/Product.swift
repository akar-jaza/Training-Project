//
//  Product.swift
//  Training Project
//
//  Created by Akar jaza on 8/30/26.
//

import Foundation

struct ProductsResponse: Codable {
    let products: [Product]
}

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: String
}
