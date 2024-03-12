//
//  BookRepository.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/12/24.
//

import Foundation
import RxSwift

protocol BookRepositoryProtocol {
    func getBookData(title: String, type: String) -> Single<Book>
}

class BookRepository: BookRepositoryProtocol {
    static let shared = BookRepository()
    
    private let disposeBag = DisposeBag()
    
    private init() {}
    
    func getBookData(title: String, type: String) -> Single<Book> {
        return BookService().getRequestForBookSearch(title: title, type: type)
            .flatMap { result -> Single<Book> in
                switch result {
                case .success(let book):
                    return .just(book)
                case .failure(let error):
                    return .error(error)
                }
            }
    }
}
