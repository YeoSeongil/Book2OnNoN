//
//  InterestedBooksRecordViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/11/24.
//

import Foundation
import RxSwift
import RxCocoa

enum InterestedBookRecordDeleteProcedureType  {
    case successDelete
    case failureDelete
}

enum InterestedBookRecordEditProcedureType  {
    case successEdit
    case failureEdit
}

protocol InterestedBookRecordViewModelType {
    // Input
    var didDeleteButtonTapped: AnyObserver<Void> { get }
    var didEditInterestedAssessmentSaveButtonTapped: AnyObserver<Void> { get }
    var didEditInterestedAssessmentValue: AnyObserver<String> { get }
    var didEditInterestedRateSaveButtonTapped: AnyObserver<Void> { get }
    var didEditInterestedInterestedRateValue: AnyObserver<Double> { get }
    
    // Output
    var resultInterestedBooksRecordData: Driver<[InterestedReadingBooks]> { get }
    var resultInterestedBookRecordDeleteProcedureType: Driver<InterestedBookRecordDeleteProcedureType> { get }
    var resultInterestedBookRecordEditProcedureType: Driver<InterestedBookRecordEditProcedureType> { get }
}

class InterestedBooksRecordViewModel {
    private let disposeBag = DisposeBag()
    private let interestedBookRecordData: InterestedReadingBooks
    
    // Input
    private let inputDeleteButtonTapped = PublishSubject<Void>()
    private let inputEditInterestedAssessmentSaveButtonTapped = PublishSubject<Void>()
    private let inputEditInterestedAssessmentValue = PublishSubject<String>()
    private let inputEditInterestedRateSaveButtonTapped = PublishSubject<Void>()
    private let inputEditInterestedRateValue = PublishSubject<Double>()

    // Output
    private let outputInterestedBooksRecordData = BehaviorRelay<[InterestedReadingBooks]>(value: [])
    private let outputInterestedBookRecordDeleteProcedureType = PublishRelay<InterestedBookRecordDeleteProcedureType>()
    private let outputInterestedBookRecordEditProcedureType = PublishRelay<InterestedBookRecordEditProcedureType>()
    
    init(interestedBookRecordData: InterestedReadingBooks) {
        self.interestedBookRecordData = interestedBookRecordData
        tryFetchData()
        tryInterestedAssessmentUpdate()
        tryInterestedRateUpdate()
        tryDeleteInterestedBookRecord()
        
        CoreDataManager.shared.observeCoreDataChanges()
            .subscribe(onNext: { [weak self] in
                self?.tryFetchData()
            })
            .disposed(by: disposeBag)
    }
    
    private func tryFetchData() {
        let predicate = NSPredicate(format: "isbn == %@", self.interestedBookRecordData.isbn ?? "")
        guard let books = CoreDataManager.shared.fetchData(InterestedReadingBooks.self, predicate: predicate) else { return }
        outputInterestedBooksRecordData.accept(books)
    }
    
    private func tryDeleteInterestedBookRecord() {
        inputDeleteButtonTapped
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                CoreDataManager.shared.deleteData(self.interestedBookRecordData)
                CoreDataManager.shared.saveData { result in
                    switch result {
                    case .success:
                        self.outputInterestedBookRecordDeleteProcedureType.accept(.successDelete)
                    case .failure(_):
                        self.outputInterestedBookRecordDeleteProcedureType.accept(.failureDelete)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func tryInterestedAssessmentUpdate() {
        inputEditInterestedAssessmentSaveButtonTapped
            .withLatestFrom(inputEditInterestedAssessmentValue)
            .subscribe(onNext: { comment in
                let predicate = NSPredicate(format: "isbn == %@", self.interestedBookRecordData.isbn ?? "")
                if let books = CoreDataManager.shared.fetchData(InterestedReadingBooks.self, predicate: predicate), let book = books.first {
                    book.comment = comment
                }
                
                CoreDataManager.shared.saveData { result in
                    switch result {
                    case .success:
                        self.outputInterestedBookRecordEditProcedureType.accept(.successEdit)
                    case .failure(let error):
                        self.outputInterestedBookRecordEditProcedureType.accept(.failureEdit)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func tryInterestedRateUpdate() {
        inputEditInterestedRateSaveButtonTapped
            .withLatestFrom(inputEditInterestedRateValue)
            .subscribe(onNext: { rate in
                let predicate = NSPredicate(format: "isbn == %@", self.interestedBookRecordData.isbn ?? "")
                if let books = CoreDataManager.shared.fetchData(InterestedReadingBooks.self, predicate: predicate), let book = books.first {
                    book.rating =  rate
                }
                CoreDataManager.shared.saveData { result in
                    switch result {
                    case .success:
                        self.outputInterestedBookRecordEditProcedureType.accept(.successEdit)
                    case .failure(let error):
                        self.outputInterestedBookRecordEditProcedureType.accept(.failureEdit)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension InterestedBooksRecordViewModel: InterestedBookRecordViewModelType {
    // Input
    var didDeleteButtonTapped: AnyObserver<Void> {
        inputDeleteButtonTapped.asObserver()
    }
    
    var didEditInterestedAssessmentSaveButtonTapped: AnyObserver<Void> {
        inputEditInterestedAssessmentSaveButtonTapped.asObserver()
    }
    
    var didEditInterestedAssessmentValue: AnyObserver<String> {
        inputEditInterestedAssessmentValue.asObserver()
    }
    
    var didEditInterestedRateSaveButtonTapped: AnyObserver<Void> {
        inputEditInterestedRateSaveButtonTapped.asObserver()
    }
    
    var didEditInterestedInterestedRateValue: AnyObserver<Double> {
        inputEditInterestedRateValue.asObserver()
    }
    
    // Output
    var resultInterestedBooksRecordData: Driver<[InterestedReadingBooks]> {
        outputInterestedBooksRecordData.asDriver(onErrorDriveWith: .empty())
    }
    
    var resultInterestedBookRecordDeleteProcedureType: Driver<InterestedBookRecordDeleteProcedureType> {
        outputInterestedBookRecordDeleteProcedureType.asDriver(onErrorDriveWith: .empty())
    }
    
    var resultInterestedBookRecordEditProcedureType: Driver<InterestedBookRecordEditProcedureType> {
        outputInterestedBookRecordEditProcedureType.asDriver(onErrorDriveWith: .empty())
    }
}
