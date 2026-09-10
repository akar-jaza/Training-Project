//
//  RecipeViewController.swift
//  Training Project
//
//  Created by Akar jaza on 9/9/26.
//

import UIKit
import RxSwift
import RxCocoa

class RecipeViewController: UIViewController, ViewCode {
    
    weak var coordinator: MainCoordinator?
    
    private let viewModel = RecipeViewModel()
    private let bag = DisposeBag()
    private let collectionView = RecipeCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Recipes"
        
        buildViewCode()
        bindCollectionView()
        viewModel.fetchRecipes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateItemSize()
    }
    
    func setupHierarchy() {
        collectionView
            .register(
                RecipeCardCell.self,
                forCellWithReuseIdentifier: RecipeCardCell.reuseID
            )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateItemSize() {
        let spacing: CGFloat = 12
        let itemsPerRow: CGFloat = 2
        
        let totalSpacing = spacing * (itemsPerRow + 1)
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / itemsPerRow
        return collectionView.layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
//        let itemWidth = (collectionView.bounds.width - spacing * 3) / 2
//        collectionView.layout.itemSize = CGSize(width: itemWidth, height: 90)
    }
    
    private func bindCollectionView() {
        
        viewModel.items.bind(to: collectionView.rx.items(
            cellIdentifier: RecipeCardCell.reuseID,
            cellType: RecipeCardCell.self
        )) { row, recipe, cell in
            
            cell.configure(
                title: recipe.name,
                description: "\(recipe.cuisine) • \(recipe.difficulty)"
            )
            
            ImageLoader.shared.loadImage(from: recipe.image) { [weak cell] image in
                if let image = image {
                    cell?.reciepeImage.image = image
                }
            }
        }
        .disposed(by: bag)
    }
}
