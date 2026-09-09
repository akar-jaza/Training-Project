//
//  Recipe.swift
//  Training Project
//
//  Created by Akar jaza on 9/9/26.
//

struct Recipe: Decodable {
    let id: Int
    let name: String
    let cuisine: String
    let difficulty: String
    let image: String
}

struct RecipesResponse: Decodable {
    let recipes: [Recipe]
}
