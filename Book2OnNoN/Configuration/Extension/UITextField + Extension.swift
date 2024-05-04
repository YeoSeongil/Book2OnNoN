//
//  UITextField + Extension.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/4/24.
//

import Foundation
import UIKit

extension UITextField {
    func addLeftViewImage(systemName: String) {
        let imageView = UIImageView(image: UIImage(systemName: systemName))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        leftViewContainer.addSubview(imageView)
        imageView.frame = leftViewContainer.bounds
        self.leftView = leftViewContainer
        self.leftViewMode = .always
    }
}
