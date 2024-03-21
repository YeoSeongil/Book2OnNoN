//
//  SearchDetailViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/13/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchRecordViewModelType {
    var testInput: AnyObserver<Void> { get }
    // Output
    var resultDetailItem: Driver<Item?> { get }
}

class SearchRecordViewModel {
    private let disposeBag = DisposeBag()
    private let item: Item
    
    var tapTest = PublishSubject<Void>()
    // Output
    var outputDetailItem = BehaviorRelay<Item?>(value: nil)
    
    init(item: Item) {
        self.item = item
        outputDetailItem.accept(item)
        tapTest.subscribe(onNext: {
            print("v")
        })
    }
}

extension SearchRecordViewModel: SearchRecordViewModelType {
    var testInput: AnyObserver<Void> {
        tapTest.asObserver()
    }
    
    var resultDetailItem: Driver<Item?> {
        outputDetailItem.asDriver()
    }
}
