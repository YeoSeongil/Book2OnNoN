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
    
    override func setViewController() {
        super.setViewController()
    }
    
    override func setConstraints() {
        super.setConstraints()
    }
    
    override func setNavigation() {
        super.setNavigation()
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self , action: #selector(bookSearchButtonTapped))
        rightButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightButton
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButton.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton
    }
    
    @objc private func bookSearchButtonTapped(_ sender: UIButton) {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}
