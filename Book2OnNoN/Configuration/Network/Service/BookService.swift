//
//  BookService.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/12/24.
//

import Foundation
import RxSwift
import Alamofire

public struct BookService {
    func paramTest(title: String, type:String) -> Observable<Result<Book, Error>>{
        return Observable.create { observer -> Disposable in
            AF.request(BookAPI.searchBook(title: title, type: type))
                .responseDecodable(of: Book.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
