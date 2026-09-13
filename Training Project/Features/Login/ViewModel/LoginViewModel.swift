import Foundation

class LoginViewModel {
    
    func authenticateUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/auth/login") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("Success")
                    completion(true)
                } else {
                    print("Failure")
                    completion(false)
                }
            }
        }.resume()
    }
    
}
