//
//  SearchDetailViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/13/24.
//

import Foundation
import RxSwift
import RxCocoa

// 어떤 타입의 저장 버튼이 눌렸지에 대한 enum
enum SaveButtonType {
    case FinishedReadingBooksSaveButton
    case ReadingBooksSaveButton
    case InterestedReadingBooksSaveButton
}

enum SaveProcedureType {
    case successSave
    case failureSave
}

protocol SearchRecordViewModelType {
    // Input
    var didSaveButtonTapped: AnyObserver<SaveButtonType> { get }
    
    var didFinishedStartReadingBookDateValue: AnyObserver<String> { get }
    var didFinishedReadingBookDateValue: AnyObserver<String> { get }
    var didFinishedReadingBookRatingValue: AnyObserver<Double> { get }
    var didFinishedReadingAssessmentTextValue: AnyObserver<String> { get }
    
    var didReadingStartReadingBookDateValue: AnyObserver<String> { get }
    var didReadingAmountOfReadingBookValue: AnyObserver<String> { get }
    
    var didInterestedAssessmentTextValue: AnyObserver<String> { get }
    var didInterestedRateValue: AnyObserver<Double> { get }
    
    // Output
    var resultLookUpItem: Driver<[LookUpItem]> { get }
    var resultSaveProcedure: Driver<SaveProcedureType> { get }
}

class SearchRecordViewModel {
    private let disposeBag = DisposeBag()
    private let item: Item
    
    // Input
    private let inputDidSaveButtonTapped = PublishSubject<SaveButtonType>()
    private let inputFinishedStartReadingBookDateValue = BehaviorSubject<String>(value: "")
    private let inputFinishedReadingBookDateValue = BehaviorSubject<String>(value: "")
    private let inputFinishedReadingBookRatingValue = BehaviorSubject<Double>(value: 2.5)
    private let inputFinishedReadingAssessmentTextValue = BehaviorSubject<String>(value: "")
    
    private let inputReadingStartReadingBookDateValue = BehaviorSubject<String>(value: "")
    private let inputReadingAmountOfReadingBookValue = BehaviorSubject<String>(value: "")
    
    private let inputInterestedAssessmentTextValue = BehaviorSubject<String>(value: "")
    private let inputInterestedRateValue = BehaviorSubject<Double>(value: 2.5)
    
    // Output
    private let outputLookUpItem = PublishRelay<[LookUpItem]>()
    private let outputSaveProcedure = PublishRelay<SaveProcedureType>()
    
    init(item: Item) {
        self.item = item
        tryGetLookUpBook()
        trySaveBookRecord()
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
    
    private func trySaveBookRecord() {
        guard let registeredUser = CoreDataManager.shared.fetchData(Book2OnNonUser.self)?.first(where: { $0.isRegister }) else {
            return
        }
        
        inputDidSaveButtonTapped
            .subscribe(onNext: { type in
                switch type {
                case .FinishedReadingBooksSaveButton:
                    self.recordFinishedReadingBook(user: registeredUser)
                case .InterestedReadingBooksSaveButton:
                    self.recordInterestedBook(user: registeredUser)
                case .ReadingBooksSaveButton:
                    self.recordReadingBook(user: registeredUser)
                }
            }).disposed(by: disposeBag)
    }
    
    private func recordFinishedReadingBook(user: Book2OnNonUser) {
        if let newRecord = CoreDataManager.shared.insertData(FinishedReadingBooks.self) {
            newRecord.name = item.title
            newRecord.isbn = item.isbn
            inputFinishedStartReadingBookDateValue.subscribe(onNext: { date in
                newRecord.startReadingDate = date
            }).disposed(by: disposeBag)
            
            inputFinishedReadingBookDateValue.subscribe(onNext: { date in
                newRecord.finishReadingDate = date
            }).disposed(by: disposeBag)
            
            inputFinishedReadingAssessmentTextValue.subscribe(onNext: { comment in
                newRecord.comment = comment
            }).disposed(by: disposeBag)
            
            inputFinishedReadingBookRatingValue.subscribe(onNext: { rating in
                newRecord.rating = rating
            }).disposed(by: disposeBag)
            
            user.addToFinishedReadingBook(newRecord)
            CoreDataManager.shared.saveData { result in
                switch result {
                case .success:
                    self.outputSaveProcedure.accept(.successSave)
                case .failure(let errorr):
                    self.outputSaveProcedure.accept(.failureSave)
                }
            }
        }
    }
    
    private func recordReadingBook(user: Book2OnNonUser) {
        if let newRecord = CoreDataManager.shared.insertData(ReadingBooks.self) {
            newRecord.name = item.title
            newRecord.isbn = item.isbn
            inputReadingStartReadingBookDateValue.subscribe(onNext: { date in
                newRecord.startReadingDate = date
            }).disposed(by: disposeBag)
            
            inputReadingAmountOfReadingBookValue.subscribe(onNext: { page in
                newRecord.readingPage = page
            }).disposed(by: disposeBag)
            
            user.addToReadingBook(newRecord)
            CoreDataManager.shared.saveData { result in
                switch result {
                case .success:
                    self.outputSaveProcedure.accept(.successSave)
                case .failure(let errorr):
                    self.outputSaveProcedure.accept(.failureSave)
                }
            }
        }
    }
    
    private func recordInterestedBook(user: Book2OnNonUser) {
        if let newRecord = CoreDataManager.shared.insertData(InterestedReadingBooks.self) {
            newRecord.name = item.title
            newRecord.isbn = item.isbn
            inputInterestedAssessmentTextValue.subscribe(onNext: { comment in
                newRecord.comment = comment
            }).disposed(by: disposeBag)
            
            inputInterestedRateValue.subscribe(onNext: { rating in
                newRecord.rating = rating
            }).disposed(by: disposeBag)
            
            user.addToInterestedReadingBook(newRecord)
            CoreDataManager.shared.saveData { result in
                switch result {
                case .success:
                    self.outputSaveProcedure.accept(.successSave)
                case .failure(let errorr):
                    self.outputSaveProcedure.accept(.failureSave)
                }
            }
        }
    }
}

extension SearchRecordViewModel: SearchRecordViewModelType {
    // Input
    var didSaveButtonTapped: AnyObserver<SaveButtonType> {
        inputDidSaveButtonTapped.asObserver()
    }
    
    var didFinishedStartReadingBookDateValue: AnyObserver<String> {
        inputFinishedStartReadingBookDateValue.asObserver()
    }
    
    var didFinishedReadingBookDateValue: AnyObserver<String> {
        inputFinishedReadingBookDateValue.asObserver()
    }
    
    var didFinishedReadingBookRatingValue: AnyObserver<Double> {
        inputFinishedReadingBookRatingValue.asObserver()
    }
    
    var didFinishedReadingAssessmentTextValue: AnyObserver<String> {
        inputFinishedReadingAssessmentTextValue.asObserver()
    }
    
    var didReadingStartReadingBookDateValue: AnyObserver<String> {
        inputReadingStartReadingBookDateValue.asObserver()
    }
    
    var didReadingAmountOfReadingBookValue: AnyObserver<String> {
        inputReadingAmountOfReadingBookValue.asObserver()
    }
    
    var didInterestedAssessmentTextValue: AnyObserver<String> {
        inputInterestedAssessmentTextValue.asObserver()
    }
    
    var didInterestedRateValue: AnyObserver<Double> {
        inputInterestedRateValue.asObserver()
    }
    
    // Output
    var resultLookUpItem: Driver<[LookUpItem]> {
        outputLookUpItem.asDriver(onErrorDriveWith: .empty())
    }
    
    var resultSaveProcedure: Driver<SaveProcedureType> {
        outputSaveProcedure.asDriver(onErrorDriveWith: .empty())
    }
}
