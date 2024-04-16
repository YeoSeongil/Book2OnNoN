//
//  HomeViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/9/24.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

protocol HomeViewModelType {
    // Input
    
    // Output
    var resultReadingBookRecordItem: Driver<[ReadingBooks]> { get }
    var resultInterestedBookRecordItem: Driver<[InterestedReadingBooks]> { get }
}

class HomeViewModel {
    // Output
    private let outputReadingBookRecordItem = BehaviorRelay<[ReadingBooks]>(value: [])
    private let outputInterestedBookRecordItem = BehaviorRelay<[InterestedReadingBooks]>(value: [])
    
    init() { 
        setupNotificationObservers()
        fetchData()
    }
    
    private func fetchData() {
        guard let readingBookItem = CoreDataManager.shared.fetchData(ReadingBooks.self) else { return }
        outputReadingBookRecordItem.accept(readingBookItem)
        
        guard let interestedBookitem = CoreDataManager.shared.fetchData(InterestedReadingBooks.self) else { return }
        outputInterestedBookRecordItem.accept(interestedBookitem)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleCoreDataChange), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc private func handleCoreDataChange() {
        fetchData()
    }
}

extension HomeViewModel: HomeViewModelType {

    // Output
    var resultReadingBookRecordItem: Driver<[ReadingBooks]> {
        outputReadingBookRecordItem.asDriver(onErrorDriveWith: .empty())
    }
    
    var resultInterestedBookRecordItem: Driver<[InterestedReadingBooks]> {
        outputInterestedBookRecordItem.asDriver(onErrorDriveWith: .empty())
    }
}

