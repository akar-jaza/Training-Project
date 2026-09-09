//
//  RecipeViewController.swift
//  Training Project
//
//  Created by Akar jaza on 9/9/26.
//

import UIKit

class RecipeViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Recipes"
    }
}
