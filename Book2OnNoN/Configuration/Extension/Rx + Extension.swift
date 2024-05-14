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
    /// Tap 제스처를 추가하여 Void 타입의 Observable을 반환한다.
    /// ```
    /// UILabel.rx.tap
    ///    .subscribe(onNext: { _ in print("Tap" }
    ///    .disposed(by: disposeBag)
    /// ```
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
