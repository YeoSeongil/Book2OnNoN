//
//  Rx + Extension.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/7/24.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
    var tap: Observable<Void> {
        let tapGestureRecognizer = UITapGestureRecognizer()
        
        base.addGestureRecognizer(tapGestureRecognizer)
        base.isUserInteractionEnabled = true
        
        let source = tapGestureRecognizer.rx.event
            .map { _ in () }
            .asObservable()
        
        return source
    }
}
