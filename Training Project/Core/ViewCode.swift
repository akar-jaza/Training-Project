//
//  ViewCode.swift
//  Training Project
//
//  Created by Akar jaza on 8/28/26.
//

import UIKit

protocol ViewCode {
    /// Add subviews to the view hierarchy
    func setupHierarchy()
    
    /// Activate Auto Layout constraints
    func setupConstraints()
    
    /// Any extra config: colors, delegates, corner radius, etc.
    func setupAdditionalConfiguration()
    
    /// Call this one method to run all three steps in order
    func buildViewCode()
}


extension ViewCode {
    func buildViewCode() {
        setupHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
    
    func setupAdditionalConfiguration() {
        // optional to override
    }
}
