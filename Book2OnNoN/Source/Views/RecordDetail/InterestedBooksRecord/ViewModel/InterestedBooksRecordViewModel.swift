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
}

class InterestedBooksRecordViewModel {
    private let interestedBookRecordData: InterestedReadingBooks
    
    private let inputDeleteButtonTapped = PublishSubject<Void>()
    
    init(interestedBookRecordData: InterestedReadingBooks) {
        self.interestedBookRecordData = interestedBookRecordData
    }
}

extension InterestedBooksRecordViewModel: InterestedBookRecordViewModelType {
    // Input
    var didDeleteButtonTapped: AnyObserver<Void> {
        inputDeleteButtonTapped.asObserver()
    }
    
}
