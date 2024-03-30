//
//  UIView + Extension.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/30/24.
//

import Foundation
import UIKit

extension UIView {
    /// 좌우로 흔들리는 진동 애니메이션을 적용합니다.
    /// ```
    /// UIView.shakeAnimation()
    /// ```
    func shakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-5.0, 5.0, -5.0, 5.0, -5.0, 5.0, -2.5, 2.5, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
