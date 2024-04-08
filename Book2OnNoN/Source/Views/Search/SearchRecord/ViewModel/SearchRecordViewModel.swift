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
}

class SearchRecordViewModel {
    private let disposeBag = DisposeBag()
    private let item: Item
    
    // Input
    var inputDidSaveButtonTapped = PublishSubject<SaveButtonType>()
    var inputFinishedStartReadingBookDateValue = BehaviorSubject<String>(value: "")
    var inputFinishedReadingBookDateValue = BehaviorSubject<String>(value: "")
    var inputFinishedReadingBookRatingValue = BehaviorSubject<Double>(value: 2.5)
    var inputFinishedReadingAssessmentTextValue = BehaviorSubject<String>(value: "")
    
    var inputReadingStartReadingBookDateValue = BehaviorSubject<String>(value: "")
    var inputReadingAmountOfReadingBookValue = BehaviorSubject<String>(value: "")
    
    var inputInterestedAssessmentTextValue = BehaviorSubject<String>(value: "")
    var inputInterestedRateValue = BehaviorSubject<Double>(value: 2.5)
    
    // Output
    var outputLookUpItem = PublishRelay<[LookUpItem]>()
    
    init(item: Item) {
        self.item = item
        tryGetLookUpBook()
        tryRecordBook()
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
    
    private func tryRecordBook() {
        guard let registeredUser = CoreDataManager.shared.fetchData(Book2OnNonUser.self)?.first(where: { $0.isRegister }) else {
                print("등록된 사용자를 찾을 수 없습니다.")
                return
        }
        
        inputDidSaveButtonTapped
            .subscribe(onNext: { type in
                switch type {
                case .FinishedReadingBooksSaveButton:
                    self.saveFinishedReadingBook(user: registeredUser)
                case .InterestedReadingBooksSaveButton:
                    self.saveInterestedBook(user: registeredUser)
                case .ReadingBooksSaveButton:
                    self.saveReadingBook(user: registeredUser)
                }
            }).disposed(by: disposeBag)
    }
    
    private func saveFinishedReadingBook(user: Book2OnNonUser) {
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
            CoreDataManager.shared.saveData()
        }
    }
    
    private func saveReadingBook(user: Book2OnNonUser) {
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
            CoreDataManager.shared.saveData()
        }
    }
    
    private func saveInterestedBook(user: Book2OnNonUser) {
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
            CoreDataManager.shared.saveData()
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
}
