//
//  UILabel + Extension.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/4/24.
//

import Foundation
import UIKit

extension UILabel {
    func addImageLabel(text: String, systemName: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let imageAttachment = NSTextAttachment()
        
        if let image = UIImage(systemName: systemName)?.withTintColor(.white, renderingMode: .alwaysOriginal) {
            imageAttachment.image = image
            
            imageAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)

            let paddingBefore = NSAttributedString(string:"   ")
            let paddingAfter = NSAttributedString(string:"   ")
            attributedString.insert(paddingBefore, at: 0)
             
             let imageString = NSAttributedString(attachment: imageAttachment)
             attributedString.insert(imageString, at: paddingBefore.length)
             
             attributedString.insert(paddingAfter, at: paddingBefore.length + imageString.length)
        }
        self.attributedText = attributedString
    }
}
