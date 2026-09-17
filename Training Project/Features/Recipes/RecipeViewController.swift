//
//  RecipeViewController.swift
//  Training Project
//
//  Created by Akar jaza on 9/9/26.
//

import UIKit
import RxSwift
import RxCocoa

final class RecipeViewController: UIViewController, ViewCode {
    
    weak var coordinator: RecipeCoordinator?
    
    private let viewModel = RecipeViewModel()
    private let bag = DisposeBag()
    private let collectionView = RecipeCollectionView()
    
    private let searchBar = UISearchBar()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Recipes"
        searchBar.placeholder = "Search recipes"
        
        buildViewCode()
        bindSearch()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateItemSize()
    }
    
    // MARK: - Setup Hierarchy

    func setupHierarchy() {
        collectionView
            .register(
                RecipeCardCell.self,
                forCellWithReuseIdentifier: RecipeCardCell.reuseID
            )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    // MARK: - Setup Constraints

    func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor
                .constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Update Item Size
    
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
    // MARK: - Binding

    private func bindSearch() {
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[Recipe]> in
                self?.viewModel.searchRecipes(query: query) ?? .just([])
            }
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(
                cellIdentifier: RecipeCardCell.reuseID,
                cellType: RecipeCardCell.self
            )) { row, recipe, cell in
                cell.configure(title: recipe.name, description: "\(recipe.cuisine) • \(recipe.difficulty)")
                
                ImageLoader.shared.loadImage(from: recipe.image) { [weak cell] image in
                    if let image = image {
                        cell?.reciepeImage.image = image
                    }
                }
            }
            .disposed(by: bag)
    }
}

// MARK: - Action Buttons
extension RecipeViewController {
    @objc private func dismissKeyboard() {
        dismiss(animated: true)
    }
}
