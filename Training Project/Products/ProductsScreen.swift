//
//  ProductsScreen.swift
//  Training Project
//
//  Created by Akar jaza on 8/29/26.
//

import UIKit
class ProductsScreen: UIViewController, ViewCode {
    weak var coordinator: MainCoordinator?
    
    func setupHierarchy() {
        //
    }

    func setupConstraints() {
        //
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Products"
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]


        buildViewCode()
    }
}
