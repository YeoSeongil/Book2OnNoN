//
//  ReadingBookRecordViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/16/24.
//

import Foundation

protocol ReadingBookRecordViewModelType {
    
}

class ReadingBookRecordViewModel {
    private let readingBookRecordData: ReadingBooks
    
    init(readingBookRecordData: ReadingBooks) {
        self.readingBookRecordData = ReadingBooks()
    }

}

extension ReadingBookRecordViewModel: ReadingBookRecordViewModelType {
    
}
