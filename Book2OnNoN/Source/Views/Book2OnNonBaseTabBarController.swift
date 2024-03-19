//
//  Book2OnNonBaseTabBarController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/12/24.
//

import UIKit
import SnapKit

final class Book2OnNonBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
    
    private func setupTabbar() {
        let homeVc = UINavigationController(rootViewController: HomeViewController())
        homeVc.navigationBar.isTranslucent = false
        homeVc.tabBarItem = UITabBarItem(title: "나의 서재", image: UIImage(systemName: "books.vertical"), selectedImage:UIImage(systemName: "books.vertical.fill"))
        
        viewControllers = [
            homeVc
        ]
        
        self.tabBar.tintColor = .white
        self.tabBar.isTranslucent = false
    }
}
