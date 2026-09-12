struct User: Codable {
    let username: String
    let email: String
    let password: String
}

struct UserResponse: Codable {
    let user: User
}
