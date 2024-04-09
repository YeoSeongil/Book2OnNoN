//
//  HomeViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/9/24.
//

import Foundation
import RxSwift
import RxCocoa

// Todo
// 나머지 데이터도 받아와 바인딩 구현

protocol HomeViewModelType {
    // Input
    
    // Output
    var resultReadingBookRecordItem: Driver<[ReadingBooks]> { get }
}

class HomeViewModel {
    // Output
    private let outputReadingBookRecordItem = BehaviorRelay<[ReadingBooks]>(value: [])
    
    init() { 
        fetchData()
    }
    
    private func fetchData() {
        guard let readingBookItem = CoreDataManager.shared.fetchData(ReadingBooks.self) else { return }
        outputReadingBookRecordItem.accept(readingBookItem)
    }
}

extension HomeViewModel: HomeViewModelType {
    // Output
    var resultReadingBookRecordItem: Driver<[ReadingBooks]> {
        outputReadingBookRecordItem.asDriver(onErrorDriveWith: .empty())
    }
}
