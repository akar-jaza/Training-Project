//
//  ViewController.swift
//  Training Project
//
//  Created by Akar jaza on 8/28/26.
//

import UIKit

class MainViewController: UIViewController, ViewCode {
    weak var coordinator: MainCoordinator?
    
    let uiCollectionViewFlowLayout = UICollectionViewFlowLayout()
    let itemsPerRow: CGFloat = 2
    let spacing: CGFloat = 10
    let buttonTitles = ["Products", "Item 2", "Item 3", "Item 4"]
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: uiCollectionViewFlowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Main"
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        buildViewCode()
    }
}
