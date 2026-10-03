//
//  FaceIDService.swift
//  Training Project
//
//  Created by Akar jaza on 10/3/26.
//


import LocalAuthentication

final class FaceIDService {

    func authenticate() async throws -> Bool {

        let context = LAContext()

        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics, // tells iOS to authenticate using enrolled biometrics. On a Face ID iPhone, that's Face ID.
            error: &error
        ) else {
            throw error ?? LAError(
                .biometryNotAvailable
            )
        }

        return try await context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Authenticate to meet your new girlfriend 😭"
        )
    }
}
