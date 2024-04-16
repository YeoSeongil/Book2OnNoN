//
//  ReadingBookRecordViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

enum ReadingBookRecordDeleteProcedureType  {
    case successDelete
    case failureDelete
}

protocol ReadingBookRecordViewModelType {
    // Input
    var didDeleteButtonTapped: AnyObserver<Void> { get }
    
    // Output
    var resultReadingBooksRecordData: Driver<[ReadingBooks]> { get }
    var resultReadingBookRecordDeleteProcedureType: Driver<ReadingBookRecordDeleteProcedureType> { get }
}

class ReadingBookRecordViewModel {
    private let disposBag = DisposeBag()
    private let readingBookRecordData: ReadingBooks
    
    // Input
    private let inputDeleteButtonTapped = PublishSubject<Void>()
    
    // Output
    private let outputReadingBooksRecordData = BehaviorRelay<[ReadingBooks]>(value: [])
    private let outputReadingBookRecordDeleteProcedureType = PublishRelay<ReadingBookRecordDeleteProcedureType>()
    
    init(readingBookRecordData: ReadingBooks) {
        self.readingBookRecordData = readingBookRecordData
        outputReadingBooksRecordData.accept([readingBookRecordData])
        tryDeleteReadingBookRecord()
    }

    private func tryDeleteReadingBookRecord() {
        inputDeleteButtonTapped
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                CoreDataManager.shared.deleteData(self.readingBookRecordData)
                CoreDataManager.shared.saveData { result in
                    switch result {
                    case .success:
                        self.outputReadingBookRecordDeleteProcedureType.accept(.successDelete)
                    case .failure(let error):
                        self.outputReadingBookRecordDeleteProcedureType.accept(.failureDelete)
                    }
                }
            })
            .disposed(by: disposBag)
    }
}

extension ReadingBookRecordViewModel: ReadingBookRecordViewModelType {
    // Input
    var didDeleteButtonTapped: AnyObserver<Void> {
        inputDeleteButtonTapped.asObserver()
    }
    
    // Output
    var resultReadingBooksRecordData: Driver<[ReadingBooks]> {
        outputReadingBooksRecordData.asDriver(onErrorDriveWith: .empty())
    }
    
    var resultReadingBookRecordDeleteProcedureType: Driver<ReadingBookRecordDeleteProcedureType> {
        outputReadingBookRecordDeleteProcedureType.asDriver(onErrorDriveWith: .empty())
    }
}
