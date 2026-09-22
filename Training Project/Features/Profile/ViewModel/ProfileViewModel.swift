import Combine
import UIKit
import Foundation

protocol ProfileViewModelDelegate: AnyObject {
    func didTapLogoutButton()
}

@MainActor
final class ProfileViewModel: ObservableObject {
    
    weak var delegate: ProfileViewModelDelegate?
    @Published var profile: Profile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var profileImage: UIImage?
    
    private let cacheService: DataCacheServiceProtocol = DataCacheService.shared

    
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
            await loadProfileImage(from: details.image)

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
    }
    
    
    private func loadProfileImage(from urlString: String) async {
        let key = cacheKey(for: urlString)
        
        if let cachedData = cacheService.loadData(forKey: key),
           let cachedImage = UIImage(data: cachedData) {
            profileImage = cachedImage
        }
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return }
            
            profileImage = image
            cacheService.saveData(data, forkey: key)
        } catch {
            // The user doesn't need to be alarmed, either the cached copy above is already showing, or ProfileView gender based fallback avatar covers it.
        }
    }
    
    // we change the URL characters into file names that can be read as a key
    // https://dummyjson.com/icon/emilys.png
    // profile_image_dummyjson.com_icon_emilys.png
    private func cacheKey(for urlString: String) -> String {
        "profile_image_" + urlString
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")
    }

}
