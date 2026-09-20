struct Recipe: Codable {
    let id: Int
    let name: String
    let cuisine: String
    let difficulty: String
    let image: String
}

struct RecipesResponse: Decodable {
    let recipes: [Recipe]
}
