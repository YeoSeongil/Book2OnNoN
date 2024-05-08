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
    var didEditStartReadingDateSaveButtonTapped: AnyObserver<Void> { get }
    var didEditStartReadingDateValue: AnyObserver<String> { get }    
    var didEditAmountOfReadingBookSaveButtonTapped: AnyObserver<Void> { get }
    var didEditAmountOfReadingBookValue: AnyObserver<Int> { get }
    
    // Output
    var resultReadingBooksRecordData: Driver<[ReadingBooks]> { get }
    var resultReadingBookLookUpItem: Driver<[LookUpItem]> { get }
    var resultReadingBookRecordDeleteProcedureType: Driver<ReadingBookRecordDeleteProcedureType> { get }
}

class ReadingBookRecordViewModel {
    private let disposeBag = DisposeBag()
    private let readingBookRecordData: ReadingBooks
    
    // Input
    private let inputDeleteButtonTapped = PublishSubject<Void>()
    private let inputEditStartReadingDateSaveButtonTapped = PublishSubject<Void>()
    private let inputEditStartReadingDateValue = PublishSubject<String>()
    private let inputEditAmountOfReadingBookSaveButtonTapped = PublishSubject<Void>()
    private let inputEditAmountOfReadingBookValue = PublishSubject<Int>()
    
    // Output
    private let outputStartReadingBookEditTapped = PublishRelay<Void>()
    private let outputAmountOfReadingBookEditTapped = PublishRelay<Void>()
    private let outputReadingBookRecordDeleteProcedureType = PublishRelay<ReadingBookRecordDeleteProcedureType>()
    private let outputReadingBooksRecordData = BehaviorRelay<[ReadingBooks]>(value: [])
    private let outputReadingBookLookUpItem = BehaviorRelay<[LookUpItem]>(value: [])
    
    init(readingBookRecordData: ReadingBooks) {
        self.readingBookRecordData = readingBookRecordData
        outputReadingBooksRecordData.accept([readingBookRecordData])
        tryGetLookUpBook()
        tryDeleteReadingBookRecord()
        tryStartReadingDateUpdate()
        tryAmountOfReadingBookUpdate()
    }

    private func tryGetLookUpBook() {
        BookRepository.shared.getLookUpItemData(isbn: self.readingBookRecordData.isbn!)
            .asObservable()
            .subscribe(onNext: { result in
                self.handleGetLookUpResult(result)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleGetLookUpResult(_ result: LookUp) {
        outputReadingBookLookUpItem.accept(result.item)
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
                    case .failure(_):
                        self.outputReadingBookRecordDeleteProcedureType.accept(.failureDelete)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func tryStartReadingDateUpdate() {
        inputEditStartReadingDateSaveButtonTapped
            .withLatestFrom(inputEditStartReadingDateValue)
            .subscribe(onNext: { date in
                let predicate = NSPredicate(format: "isbn == %@", self.readingBookRecordData.isbn ?? "")
                if let books = CoreDataManager.shared.fetchData(ReadingBooks.self, predicate: predicate), let book = books.first {
                    book.startReadingDate = date
                }
                
                CoreDataManager.shared.saveData { result in
                    switch result {
                    case .success:
                        print("성공")
                    case .failure(let error):
                        print("실패")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func tryAmountOfReadingBookUpdate() {
        inputEditAmountOfReadingBookSaveButtonTapped
            .withLatestFrom(inputEditAmountOfReadingBookValue)
            .subscribe(onNext: { amountOfReadingBook in
                let predicate = NSPredicate(format: "isbn == %@", self.readingBookRecordData.isbn ?? "")
                if let books = CoreDataManager.shared.fetchData(ReadingBooks.self, predicate: predicate), let book = books.first {
                    book.readingPage = Int32(amountOfReadingBook)
                }
                CoreDataManager.shared.saveData { result in
                    switch result {
                    case .success:
                        print("성공")
                    case .failure(let error):
                        print("실패")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ReadingBookRecordViewModel: ReadingBookRecordViewModelType {
    // Input
    var didDeleteButtonTapped: AnyObserver<Void> {
        inputDeleteButtonTapped.asObserver()
    }
    
    var didEditStartReadingDateSaveButtonTapped: AnyObserver<Void> {
        inputEditStartReadingDateSaveButtonTapped.asObserver()
    }
    
    var didEditStartReadingDateValue: AnyObserver<String> {
        inputEditStartReadingDateValue.asObserver()
    }
    
    var didEditAmountOfReadingBookSaveButtonTapped: AnyObserver<Void> {
        inputEditAmountOfReadingBookSaveButtonTapped.asObserver()
    }
    
    var didEditAmountOfReadingBookValue: AnyObserver<Int> {
        inputEditAmountOfReadingBookValue.asObserver()
    }
    
    // Output
    var resultReadingBooksRecordData: Driver<[ReadingBooks]> {
        outputReadingBooksRecordData.asDriver(onErrorDriveWith: .empty())
    }
    
    var resultReadingBookRecordDeleteProcedureType: Driver<ReadingBookRecordDeleteProcedureType> {
        outputReadingBookRecordDeleteProcedureType.asDriver(onErrorDriveWith: .empty())
    }

    var resultReadingBookLookUpItem: Driver<[LookUpItem]> {
        outputReadingBookLookUpItem.asDriver(onErrorDriveWith: .empty())
    }
}
