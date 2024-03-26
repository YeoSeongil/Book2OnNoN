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
    // Input
    var didRecordSaveButtonTapped: AnyObserver<Void> { get }
    var didRecordButtonTapped: AnyObserver<String> { get }
    
    // Output
    var resultLookUpItem: Driver<[LookUpItem]> { get }
}

class SearchRecordViewModel {
    private let disposeBag = DisposeBag()
    private let item: Item
    
    // Input
    var inputRecordSaveButtonTapped = PublishSubject<Void>()
    var inputRecordFinishedReadingButtonTapped = BehaviorSubject<String>(value: "finish")
    
    // Output
    var outputLookUpItem = PublishRelay<[LookUpItem]>()
    
    init(item: Item) {
        self.item = item
        tryGetLookUpBook()
    }
                                                                                        
    private func test() {
        inputRecordSaveButtonTapped.withLatestFrom(inputRecordFinishedReadingButtonTapped)
            .subscribe(onNext: { str in
                print(str)
            })
    }
    
    private func tryGetLookUpBook() {
        BookRepository.shared.getLookUpItemData(isbn: item.isbn)
            .asObservable()
            .subscribe(onNext: { result in
                self.handleGetLookUpResult(result)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleGetLookUpResult(_ result: LookUp) {
        outputLookUpItem.accept(result.item)
    }
}

extension SearchRecordViewModel: SearchRecordViewModelType {
    // Input
    var didRecordSaveButtonTapped: AnyObserver<Void> {
        inputRecordSaveButtonTapped.asObserver()
    }
    
    var didRecordButtonTapped: AnyObserver<String> {
        inputRecordFinishedReadingButtonTapped.asObserver()
    }
    
    // Output
    var resultLookUpItem: Driver<[LookUpItem]> {
        outputLookUpItem.asDriver(onErrorDriveWith: .empty())
    }
}
