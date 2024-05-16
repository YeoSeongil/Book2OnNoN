//
//  FinishedReadingBookRecordViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/16/24.
//

import Foundation
import RxSwift
import RxCocoa

enum FinishedReadingBookRecordDeleteProcedureType  {
    case successDelete
    case failureDelete
}

enum FinishedReadingBookRecordEditProcedureType  {
    case successEdit
    case failureEdit
}

protocol FinishedReadingBookRecordViewModelType {
    // Input
    var didDeleteButtonTapped: AnyObserver<Void> {get}
    
    // Output
    var resultFinishedReadingBookRecordData: Driver<[FinishedReadingBooks]> { get }
    var resultFinishedReadingBookRecordDeleteProcedureType: Driver<FinishedReadingBookRecordDeleteProcedureType> { get }
    var resultFinishedReadingBookRecordEditProcedureType: Driver<FinishedReadingBookRecordEditProcedureType> { get }
}

class FinishedReadingBookRecordViewModel {
    private let disposeBag = DisposeBag()
    private let finishedReadingBookRecordData: FinishedReadingBooks
    
    // Input
    private let inputDeleteButtonTapped = PublishSubject<Void>()
    
    // Output
    private let outputFinishedReadingBookRecordData = BehaviorRelay<[FinishedReadingBooks]>(value: [])
    private let outputFinishedReadingBookRecordDeleteProcedureType = PublishRelay<FinishedReadingBookRecordDeleteProcedureType>()
    private let outputFinishedReadingBookRecordEditProcedureType = PublishRelay<FinishedReadingBookRecordEditProcedureType>()
    
    init(finishedReadingBookRecordData: FinishedReadingBooks) {
        self.finishedReadingBookRecordData = finishedReadingBookRecordData
        tryFetchData()
        tryDeleteFinishedReadingBookRecord()
    }
    
    private func tryFetchData() {
        let predicate = NSPredicate(format: "isbn == %@", self.finishedReadingBookRecordData.isbn ?? "")
        guard let books = CoreDataManager.shared.fetchData(FinishedReadingBooks.self, predicate: predicate) else { return }
        outputFinishedReadingBookRecordData.accept(books)
    }
    
    private func tryDeleteFinishedReadingBookRecord() {
        inputDeleteButtonTapped
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                CoreDataManager.shared.deleteData(self.finishedReadingBookRecordData)
                CoreDataManager.shared.saveData { result in
                    switch result {
                    case .success:
                        self.outputFinishedReadingBookRecordDeleteProcedureType.accept(.successDelete)
                    case .failure(_):
                        self.outputFinishedReadingBookRecordDeleteProcedureType.accept(.failureDelete)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
}

extension FinishedReadingBookRecordViewModel: FinishedReadingBookRecordViewModelType {
    // Input
    var didDeleteButtonTapped: AnyObserver<Void> {
        inputDeleteButtonTapped.asObserver()
    }
    
    // Output
    var resultFinishedReadingBookRecordData: Driver<[FinishedReadingBooks]> {
        outputFinishedReadingBookRecordData.asDriver(onErrorDriveWith: .empty())
    }
    
    var resultFinishedReadingBookRecordDeleteProcedureType: Driver<FinishedReadingBookRecordDeleteProcedureType> {
        outputFinishedReadingBookRecordDeleteProcedureType.asDriver(onErrorDriveWith: .empty())
    }
    
    var resultFinishedReadingBookRecordEditProcedureType: Driver<FinishedReadingBookRecordEditProcedureType> {
        outputFinishedReadingBookRecordEditProcedureType.asDriver(onErrorDriveWith: .empty())
    }
}
