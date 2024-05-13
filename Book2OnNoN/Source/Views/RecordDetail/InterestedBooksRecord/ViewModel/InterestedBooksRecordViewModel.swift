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
    
    // Output
    var resultInterestedBooksRecordData: Driver<[InterestedReadingBooks]> { get }
}

class InterestedBooksRecordViewModel {
    private let interestedBookRecordData: InterestedReadingBooks
    
    // Input
    private let inputDeleteButtonTapped = PublishSubject<Void>()
   
    // Output
    private let outputInterestedBooksRecordData = BehaviorRelay<[InterestedReadingBooks]>(value: [])
    
    init(interestedBookRecordData: InterestedReadingBooks) {
        self.interestedBookRecordData = interestedBookRecordData
        tryFetchData()
    }
    
    private func tryFetchData() {
        let predicate = NSPredicate(format: "isbn == %@", self.interestedBookRecordData.isbn ?? "")
        guard let books = CoreDataManager.shared.fetchData(InterestedReadingBooks.self, predicate: predicate) else { return }
        outputInterestedBooksRecordData.accept(books)
    }
}

extension InterestedBooksRecordViewModel: InterestedBookRecordViewModelType {
    // Input
    var didDeleteButtonTapped: AnyObserver<Void> {
        inputDeleteButtonTapped.asObserver()
    }
    
    // Output
    var resultInterestedBooksRecordData: Driver<[InterestedReadingBooks]> {
        outputInterestedBooksRecordData.asDriver(onErrorDriveWith: .empty())
    }
    
}
