import Testing
import SwiftUI
import Foundation
@testable import Training_Project


struct ProfileViewModelTests {
    
    @Test @MainActor // silencing warning: (Main actor-isolated initializer 'init(keychain:)' cannot be called from outside of the actor; this is an error in the Swift 6 language mode) Swift may complain that you are accessing ProfileViewModel from the wrong concurrency context.
    func testFetchProfileInfo() async {
        let session = MockUserSessionService()
        let mockNetwork = MockNetworkService()
        
        let user = User(
            id: 1,
            username: "Akar",
            email: "akar@dummyjsonmail.com",
            firstName: "Akar",
            lastName: "Jaza",
            gender: "male",
            image: "",
            token: "abc123",
            refreshToken: "abc123"
        )
        session.save(user)
        
        let expectedProfile = Profile(
            id: 1,
            username: "Akar",
            email: "akar@dummyjsonmail.com",
            firstName: "Akar",
            lastName: "Jaza",
            age: 25,
            gender: "male",
            image: "",
            bloodGroup: "O+",
            height: 180,
            weight: 75,
            eyeColor: "Brown"
        )
        mockNetwork.result = .success(expectedProfile)
        
        let viewModel = ProfileViewModel(
            networkService: mockNetwork,
            localUser: session
            
        )
        
        await viewModel.loadProfile()
        
        #expect(viewModel.profile?.id == expectedProfile.id)
        #expect(viewModel.profile?.email == expectedProfile.email)
        #expect(mockNetwork.lastRequestedURL?.absoluteString ==
                "https://dummyjson.com/users/1")
    }
    
    @Test @MainActor
    private func testFetchProfileOnErr() async {
        let session = MockUserSessionService()
        let mockNetwork = MockNetworkService()
        
        let user = User(
            id: 1,
            username: "Akar",
            email: "akar@dummyjsonmail.com",
            firstName: "Akar",
            lastName: "Jaza",
            gender: "male",
            image: "",
            token: "abc123",
            refreshToken: "abc123"
        )
        session.save(user)
        
        mockNetwork.result = .failure(NetworkError.invalidURL)
        
        let viewModel = ProfileViewModel(
            networkService: mockNetwork,
            localUser: session
        )
        
        await viewModel.loadProfile()
        
        #expect(viewModel.profile == nil)
        #expect(viewModel.errorMessage == "Couldn't refresh profile.")
    }
    
    @Test @MainActor
    func testLoadsProfileImage() async throws {
        let session = MockUserSessionService()
        let network = MockNetworkService()
        let cache = MockDataCacheService()
        
        let user = User(
            id: 1,
            username: "Akar",
            email: "akar@dummyjsonmail.com",
            firstName: "Akar",
            lastName: "Jaza",
            gender: "male",
            image: "",
            token: "token",
            refreshToken: "refreshToken"
        )
        session.save(user)
        
        
        let profile = Profile(
            id: 1,
            username: "Akar",
            email: "akar@dummyjsonmail.com",
            firstName: "Akar",
            lastName: "Jaza",
            age: 25,
            gender: "male",
            image: "https://dummyjsonmail.com/profile.png",
            bloodGroup: "O+",
            height: 180,
            weight: 75,
            eyeColor: "Brown"
        )
        
        let testImage = try #require(UIImage(systemName: "person.circle"))
        let imageData = try #require(testImage.pngData())
        
        network.result = .success(profile)
        network.imageResult = .success(imageData)
        
        let viewModel = ProfileViewModel(
            networkService: network,
            cacheService: cache,
            localUser: session
        )
        
        await viewModel.loadProfile()
        
        #expect(viewModel.profileImage != nil)
        #expect(cache.lastLoadedKey ==
                "profile_image_dummyjsonmail.com_profile.png")
    }
    
    @Test @MainActor
    private func testCacheKey() {
        let url: String = "https://dummyjson.com/icon/emilys.png"
        
        let viewModel = ProfileViewModel()
        
        let cacheKeyResult = viewModel.cacheKey(for: url)
        
        #expect(cacheKeyResult == "profile_image_dummyjson.com_icon_emilys.png")
    }
}
