//
//  UIImageView + Extension.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/13/24.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    /// 이미지 URL을 Parsing하여 imageView로 생성합니다.
    /// ```
    /// UIImageView.setImageKingfisher(with: imageURL)
    /// ```
    /// - Parameters:
    ///   - urlString: 이미지 URL
    func setImageKingfisher(with urlString: String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        kf.indicatorType = .activity
        kf.setImage(with: url)
    }
}
