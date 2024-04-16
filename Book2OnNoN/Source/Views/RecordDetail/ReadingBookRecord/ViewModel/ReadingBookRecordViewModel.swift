//
//  ReadingBookRecordViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReadingBookRecordViewModelType {
    // Output
    var ResultReadingBooksRecordData: Driver<[ReadingBooks]> { get }
}

class ReadingBookRecordViewModel {
    private let readingBookRecordData: ReadingBooks
    
    // Output
    private let outputReadingBooksRecordData = BehaviorRelay<[ReadingBooks]>(value: [])
    
    init(readingBookRecordData: ReadingBooks) {
        self.readingBookRecordData = ReadingBooks()
        outputReadingBooksRecordData.accept([readingBookRecordData])
    }

}

extension ReadingBookRecordViewModel: ReadingBookRecordViewModelType {
    var ResultReadingBooksRecordData: Driver<[ReadingBooks]> {
        outputReadingBooksRecordData.asDriver(onErrorDriveWith: .empty())
    }
}
