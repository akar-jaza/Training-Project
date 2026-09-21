import Combine
import UIKit
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadProfile() async {
        let localUser = UserSessionService.shared.getCurrentUser()
//        user = localUser
        
        guard let localUser,
              let url = URL(string: "https://dummyjson.com/users/\(localUser.id)") else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let details = try JSONDecoder().decode(Profile.self, from: data)
            
            profile = details 
//            profile = Profile(
//                id: details.id,
//                username: details.username,
//                email: details.email,
//                firstName: details.firstName,
//                lastName: details.lastName,
//                gender: details.gender,
//                image: details.image,
//                bloodGroup: details.bloodGroup,
//                height: details.height,
//                weight: details.weight,
//                eyeColor: details.eyeColor,
//            )
        }
        catch {
            print("Couldn't refresh profile: \(error)")
            errorMessage = "Couldn't refresh profile."
        }
        
        func logout() {
            UserSessionService.shared.clear()
        }
    }
}
