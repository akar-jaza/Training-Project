import Testing
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
}
