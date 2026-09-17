//
//  RecipeCollectionView.swift
//  Training Project
//
//  Created by Akar jaza on 9/10/26.
//

import UIKit
final class RecipeCollectionView: UICollectionView {
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        return layout
    }()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



