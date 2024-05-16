//
//  MyLibraryViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/16/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyLibraryViewModelType {
    // Output
    var finishedReadingBookRecordItem: Driver<[FinishedReadingBooks]> { get }
}

class MyLibraryViewModel {
     private let disposeBag = DisposeBag()
    
    // Output
    private let outputFinishedReadingBookRecordItem = BehaviorRelay<[FinishedReadingBooks]>(value: [])
    
    init()  {
        fetchData()
        setupNotificationObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    private func fetchData() {
        guard let finishedReadingBookItem = CoreDataManager.shared.fetchData(FinishedReadingBooks.self) else { return }
        outputFinishedReadingBookRecordItem.accept(finishedReadingBookItem)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleCoreDataChange), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc private func handleCoreDataChange() {
        fetchData()
    }
}

extension MyLibraryViewModel: MyLibraryViewModelType {
    // Output
    var finishedReadingBookRecordItem: Driver<[FinishedReadingBooks]> {
        outputFinishedReadingBookRecordItem.asDriver(onErrorDriveWith: .empty())
    }
}
