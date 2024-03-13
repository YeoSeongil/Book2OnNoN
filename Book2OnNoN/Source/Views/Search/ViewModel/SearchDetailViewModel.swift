//
//  SearchDetailViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/13/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchDetailViewModelType {
    // Output
    var resultDetailItem: Driver<Item?> { get }
}

class SearchDetailViewModel {
    private let disposeBag = DisposeBag()
    private let item: Item
    
    // Output
    var outputDetailItem = BehaviorRelay<Item?>(value: nil)
    
    init(item: Item) {
        self.item = item
        outputDetailItem.accept(item)
    }
}

extension SearchDetailViewModel: SearchDetailViewModelType {
    var resultDetailItem: Driver<Item?> {
        outputDetailItem.asDriver()
    }
}
