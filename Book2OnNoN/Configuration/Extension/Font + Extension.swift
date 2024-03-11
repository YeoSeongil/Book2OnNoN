//
//  Font + Extension.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/11/24.
//

import Foundation
import UIKit

extension UIFont {
    // MARK: - Pretendard Font
    enum Pretendard  {
        enum name: String {
            case light = "Pretendard-Light"
            case medium = "Pretendard-Medium"
            case regular = "Pretendard-Regular"
            case semibold = "Pretendard-SemiBold"
            case bold = "Pretendard-Bold"
        }
        
        enum Size: CGFloat {
            case light = 12.0
            case medium = 13.0
            case regular = 14.0
            case semibold = 16.0
            case bold = 20.0
            case title = 27.0
        }
        
        static let light = UIFont(name: Pretendard.name.light.rawValue, size: Pretendard.Size.light.rawValue)
        static let medium = UIFont(name: Pretendard.name.medium.rawValue, size: Pretendard.Size.medium.rawValue)
        static let regular = UIFont(name: Pretendard.name.regular.rawValue, size: Pretendard.Size.regular.rawValue)
        static let semibold = UIFont(name: Pretendard.name.semibold.rawValue, size: Pretendard.Size.semibold.rawValue)
        static let bold = UIFont(name: Pretendard.name.bold.rawValue, size: Pretendard.Size.bold.rawValue)
        static let title = UIFont(name: Pretendard.name.bold.rawValue, size: Pretendard.Size.title.rawValue)
    }
}
