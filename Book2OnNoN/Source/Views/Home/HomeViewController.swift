//
//  HomeViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override func setViewController() {
        super.setViewController()
    }
    
    override func setConstraints() {
        super.setConstraints()
    }
    
    override func setNavigation() {
        super.setNavigation()
    
        let rightButton = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = rightButton
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButton.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton
    }
    
    override func bind() {
        searchButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigationController?.pushViewController(SearchViewController(), animated: true)
            }).disposed(by: disposeBag)
    }
}
