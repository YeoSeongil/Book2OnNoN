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

enum ReadingBookRecordEditProcedureType  {
    case successEdit
    case failureEdit
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
    var resultReadingBookRecordEditProcedureType: Driver<ReadingBookRecordEditProcedureType> { get }
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
    private let outputReadingBookRecordEditProcedureType = PublishRelay<ReadingBookRecordEditProcedureType>()
    private let outputReadingBooksRecordData = BehaviorRelay<[ReadingBooks]>(value: [])
    private let outputReadingBookLookUpItem = BehaviorRelay<[LookUpItem]>(value: [])
    
    
    init(readingBookRecordData: ReadingBooks) {
        self.readingBookRecordData = readingBookRecordData
        tryFetchData()
        tryGetLookUpBook()
        tryDeleteReadingBookRecord()
        tryStartReadingDateUpdate()
        tryAmountOfReadingBookUpdate()
        setupNotificationObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleCoreDataChange), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc private func handleCoreDataChange() {
        tryFetchData()
    }
    
    private func tryFetchData() {
        let predicate = NSPredicate(format: "isbn == %@", self.readingBookRecordData.isbn ?? "")
        guard let books = CoreDataManager.shared.fetchData(ReadingBooks.self, predicate: predicate) else { return }
        outputReadingBooksRecordData.accept(books)
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
                        self.outputReadingBookRecordEditProcedureType.accept(.successEdit)
                    case .failure(let error):
                        self.outputReadingBookRecordEditProcedureType.accept(.failureEdit)
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
                        self.outputReadingBookRecordEditProcedureType.accept(.successEdit)
                    case .failure(let error):
                        self.outputReadingBookRecordEditProcedureType.accept(.failureEdit)
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
    
    var resultReadingBookRecordEditProcedureType: Driver<ReadingBookRecordEditProcedureType> {
        outputReadingBookRecordEditProcedureType.asDriver(onErrorDriveWith: .empty())
    }
}
