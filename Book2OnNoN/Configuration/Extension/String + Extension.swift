//
//  String + Extension.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/8/24.
//

import UIKit

extension String {
    /// 문자열에서 숫자만 추출하여 `Int`로 변환합니다.
    /// 변환이 실패하면 `nil`을 반환합니다.
    /// ```
    /// String.extractDigitsToInt()
    /// ```
    func extractDigitsToInt() -> Int? {

        let digitCharacterSet = CharacterSet.decimalDigits
        let numericString = self.unicodeScalars.filter {
            digitCharacterSet.contains($0)
        }
        .map { Character($0) }
        .map { String($0) }
        .joined()
        
        return Int(numericString)
    }
}
