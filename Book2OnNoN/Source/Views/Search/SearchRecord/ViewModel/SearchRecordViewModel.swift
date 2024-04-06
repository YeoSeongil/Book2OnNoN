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
    var didFinishedReadingBooksSaveButtonTapped: AnyObserver<Void> { get }
    var didFinishedReadingStartReadingBookDateValue: AnyObserver<String> { get }
    var didFinishedReadingBookDateValue: AnyObserver<String> { get }
    var didFinishedReadingBookRatingValue: AnyObserver<Double> { get }
    var didFinishedReadingAssessmentTextValue: AnyObserver<String> { get }
    
    var didReadingBooksSaveButtonTapped: AnyObserver<Void> { get }
    var didReadingStartReadingBookDateValue: AnyObserver<String> { get }
    var didReadingAmountOfReadingBookValue: AnyObserver<String> { get }
    
    var didInterestedReadingBooksSaveButtonTapped: AnyObserver<Void> { get }
    var didInterestedAssessmentTextValue: AnyObserver<String> { get }
    var didInterestedRateValue: AnyObserver<String> { get }
    
    
    // Output
    var resultLookUpItem: Driver<[LookUpItem]> { get }
}

class SearchRecordViewModel {
    private let disposeBag = DisposeBag()
    private let item: Item
    
    // Input
    var inputFinishedReadingBooksSaveButtonTapped = PublishSubject<Void>()
    var inputFinishedReadingStartReadingBookDateValue = PublishSubject<String>()
    var inputFinishedReadingBookDateValue = PublishSubject<String>()
    var inputFinishedReadingBookRatingValue = PublishSubject<Double>()
    var inputFinishedReadingAssessmentTextValue = PublishSubject<String>()
    
    var inputReadingBooksSaveButtonTapped = PublishSubject<Void>()
    var inputReadingStartReadingBookDateValue = PublishSubject<String>()
    var inputReadingAmountOfReadingBookValue = PublishSubject<String>()
    
    var inputInterestedReadingBooksSaveButtonTapped = PublishSubject<Void>()
    var inputInterestedAssessmentTextValue = PublishSubject<String>()
    var inputInterestedRateValue = PublishSubject<String>()
    
    // Output
    var outputLookUpItem = PublishRelay<[LookUpItem]>()
    
    init(item: Item) {
        self.item = item
        tryGetLookUpBook()
        inputFinishedReadingBooksSaveButtonTapped
            .subscribe { _ in
                self.test()
            }
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
    
    // Todo
    // 나머지 항목도 CoreData에 제대로 전송 되는지 확인
    // 코드 간결하게 생각해보기
    private func test() {
        guard let registeredUser = CoreDataManager.shared.fetchData(Book2OnNonUser.self)?.first(where: { $0.isRegister }) else {
            print("등록된 사용자를 찾을 수 없습니다.")
            return
        }
        
        // 관심 도서 추가
        if let newBook = CoreDataManager.shared.insertData(FinishedReadingBooks.self) {
            newBook.name = "책2"
            newBook.isbn = "12345"
            inputFinishedReadingStartReadingBookDateValue.subscribe(onNext: { a in
                newBook.startReadingDate = a
            }).disposed(by: disposeBag)
            
            inputFinishedReadingBookDateValue.subscribe(onNext: { a in
                newBook.finishReadingDate = a
            }).disposed(by: disposeBag)
            
            inputFinishedReadingAssessmentTextValue.subscribe(onNext: { a in
                newBook.comment = a
            }).disposed(by: disposeBag)
            
            inputFinishedReadingBookRatingValue.subscribe(onNext: { a in
                newBook.rating = 5.0
            }).disposed(by: disposeBag)
            
            // 사용자와 관심 도서 간의 관계 설정
            registeredUser.addToFinishedReadingBook(newBook)
            
            // 변경 사항 저장
            CoreDataManager.shared.saveData()
        }
    }
}

extension SearchRecordViewModel: SearchRecordViewModelType {
    // Input
    var didFinishedReadingBooksSaveButtonTapped: AnyObserver<Void> {
        inputFinishedReadingBooksSaveButtonTapped.asObserver()
    }
    
    var didFinishedReadingStartReadingBookDateValue: AnyObserver<String> {
        inputFinishedReadingStartReadingBookDateValue.asObserver()
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
    
    var didReadingBooksSaveButtonTapped: AnyObserver<Void> {
        inputReadingBooksSaveButtonTapped.asObserver()
    }
    
    var didReadingStartReadingBookDateValue: AnyObserver<String> {
        inputReadingStartReadingBookDateValue.asObserver()
    }
    
    var didReadingAmountOfReadingBookValue: AnyObserver<String> {
        inputReadingAmountOfReadingBookValue.asObserver()
    }
    
    var didInterestedReadingBooksSaveButtonTapped: AnyObserver<Void> {
        inputInterestedReadingBooksSaveButtonTapped.asObserver()
    }
    
    var didInterestedAssessmentTextValue: AnyObserver<String> {
        inputInterestedAssessmentTextValue.asObserver()
    }
    
    var didInterestedRateValue: AnyObserver<String> {
        inputInterestedRateValue.asObserver()
    }

    // Output
    var resultLookUpItem: Driver<[LookUpItem]> {
        outputLookUpItem.asDriver(onErrorDriveWith: .empty())
    }
}
