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
    weak var coordinator: MainCoordinator?
    private let rxViewModel = RxProductViewModel()
    private let rxProductView = RxProductView()
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
    }
}
