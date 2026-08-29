//
//  Coordinator.swift
//  Training Project
//
//  Created by Akar jaza on 8/29/26.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
