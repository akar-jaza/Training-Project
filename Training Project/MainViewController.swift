//
//  ViewController.swift
//  Training Project
//
//  Created by Akar jaza on 8/28/26.
//

import UIKit

class MainViewController: UIViewController, ViewCode {
    
    let uiCollectionViewFlowLayout = UICollectionViewFlowLayout()
    let itemsPerRow: CGFloat = 2
    let spacing: CGFloat = 10
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: uiCollectionViewFlowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        buildViewCode()
    }
}
