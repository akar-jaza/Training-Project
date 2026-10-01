import Testing
import Foundation
@testable import Training_Project

struct LoginViewModelTests {
    
    @Test func authenticateUser_onSuccess_tellsDelegateTheUser() {
        let mockNetwork = MockNetworkService()
        
        let fakeUser = User(
            id: 1,
            username: "emilys",
            email: "emily@x.com",
            firstName: "Emily",
            lastName: "Johnson",
            gender: "female",
            image: "",
            token: "abc123",
            refreshToken: "abc123"
        )
        
        mockNetwork.result = .success(fakeUser)
        
        let delegate = MockLoginViewModelDelegate()
        let viewModel = LoginViewModel(networkService: mockNetwork)
        viewModel.delegate = delegate
        
        viewModel.authenticateUser(username: "emilys", password: "emilyspass")
        #expect(delegate.didAuthenticateUser?.username == "emilys")
        #expect(delegate.didFailWithError == nil)
    }
    
    @Test func authenticateUser_onFailure_tellsDelegateTheError() {
        let mockNetwork = MockNetworkService()
        mockNetwork.result = .failure(NetworkError.serverError(400, Data()))
        
        let delegate = MockLoginViewModelDelegate()
        let viewModel = LoginViewModel(networkService: mockNetwork)
        
        viewModel.delegate = delegate
        
        viewModel.authenticateUser(username: "wrong", password: "wrong")
        
        #expect(delegate.didFailWithError != nil)
        #expect(delegate.didAuthenticateUser == nil)
    }

    
    @Test func authenticateUser_callsTheCorrectEndpoint() {
        let mockNetwork = MockNetworkService()
        mockNetwork.result = .failure(NetworkError.noData)
        
        let viewModel = LoginViewModel(networkService: mockNetwork)
        viewModel.authenticateUser(username: "emilys", password: "emilyspass")
        
        #expect(mockNetwork.lastRequestedURL?.absoluteString == "https://dummyjson.com/auth/login")
    }
    
    @Test func authenticateUser_callsTheWrongEndpoint() {
        let mockNetwork = MockNetworkService()
        mockNetwork.result = .failure(NetworkError.invalidURL)
        
        let viewModel = LoginViewModel(networkService: mockNetwork)
        viewModel.authenticateUser(username: "emilys", password: "emilyspass")
        
        #expect(mockNetwork.lastRequestedURL?.absoluteString != "https://dummyjson.com/auth/refresh")
    }
    
}
