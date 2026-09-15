struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let image: String
    let token: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case id, username, email, firstName, lastName, gender, image
        case token = "accessToken"
        case refreshToken
    }
}
