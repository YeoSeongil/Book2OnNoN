//
//  UIViewController + Extension.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/30/24.
//

import Foundation
import UIKit

extension UIViewController {
    /// 확인 버튼만 클릭할 수 있는 Alert를 Show 합니다.
    /// ```
    /// UIViewController.showOnlyOkAlert(title: "경고", message: "잘못 되었습니다.", buttonTitle: "확인")
    /// ```
    /// - Parameters:
    ///   - title: Alert의 Title Text
    ///   - message: Alert의 Message Text
    ///   - buttonTitle: Alert의 Button Title
    func showOnlyOkAlert(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        let alertSheet = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertSheet.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: handler))
        self.present(alertSheet, animated: true)
    }
}
