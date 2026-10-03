import Combine
import LocalAuthentication

@MainActor
final class FaceIDViewModel: ObservableObject {

    @Published private(set) var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isEnrolled: Bool = false

    private let faceIDService: FaceIDService

    init(
        faceIDService: FaceIDService? = nil
    ) {
        self.faceIDService =
            faceIDService ?? FaceIDService()
    }
    
    // refresh the status of the faceid authentication
    func refreshStatus() {
        let context = LAContext()
        isEnrolled = context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: nil
        )
    }

    // authenticate the faceid
    func authenticate() async {

        errorMessage = nil

        do {

            let success =
                try await faceIDService.authenticate()

            if success {
                isAuthenticated = true
            }

        } catch {

            errorMessage = error.localizedDescription
        }
    }
}
