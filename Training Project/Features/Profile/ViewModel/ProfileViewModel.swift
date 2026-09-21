import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadProfile() async {
        let localUser = UserSessionService.shared.getCurrentUser()
        user = localUser
        
        guard let localUser,
              let url = URL(string: "https://dummyjson.com/users/\(localUser.id)") else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let details = try JSONDecoder().decode(ProfileDetailsResponse.self, from: data)
            
            user = User(
                id: details.id,
                username: details.username,
                email: details.email,
                firstName: details.firstName,
                lastName: details.lastName,
                gender: details.gender,
                image: details.image,
                token: localUser.token,
                refreshToken: localUser.refreshToken
            )
        }
        catch {
            errorMessage = "Couldn't refresh profile: \(error.localizedDescription)"
        }
        
        func logout() {
            UserSessionService.shared.clear()
        }
    }
}
