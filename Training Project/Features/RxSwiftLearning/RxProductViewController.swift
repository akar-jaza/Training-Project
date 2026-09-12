//
//  RxProductViewController.swift
//  Training Project
//
//  Created by Akar jaza on 9/8/26.
//

import UIKit
import RxSwift
import RxCocoa

class RxProductViewController: UIViewController {
    weak var coordinator: AppCoordinator?
    
    // MARK: - Computed property to access our custom view

//    private var productView: RxProductView { view as! RxProductView }
    private var productView = RxProductView()
    
    private let viewModel = RxProductViewModel()
    private let bag = DisposeBag()
    
    override func loadView() {
        view = productView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableData()
    }
    
    
    private func bindTableData() {
        let tableView = productView.tableView
        
        // first we need to bind the product items to the table
        viewModel.items.bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)
        ) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
            cell.imageView?.tintColor = AppColors.primaryColor
        }.disposed(by: bag)
        
        // second, bind a model selected handler
        tableView.rx.modelSelected(RxProduct.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        
        // finally fetch the items via the view model
        viewModel.fetchItems()
    }
}

