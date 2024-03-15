//
//  SearchViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/11/24.
//

import Foundation
import RxSwift
import RxCocoa

enum SearchError: Error {
    case emptySearchText
    case noResults
}

protocol SearchViewModelType {
    // Input
    var searchDropDownButtonTapped: AnyObserver<Void> { get } // SearchDropDown Button이 Tapped 되었는지 옵저빙
    var searchTextFieldInputTextValue: AnyObserver<String> { get } // SearchTextField에 입력 된 Text Value를 옵저빙
    var searchEditingDidEnd: AnyObserver<Void> { get } // Search TextField의 입력이 끝났는지 옵저빙
    var whichSelectedDropDownItem: AnyObserver<String> { get } // 어떤 DropDownItem이 선택 되었는지 옵저빙
    
    // Output
    var resultDownButtonTapped: Driver<[String]> { get }
    var resultSearch: Driver<[Book]> { get }
    var resultSearchItem: Driver<[Item]> { get }
    var resultSearchError: Driver<SearchError> { get }
}

class SearchViewModel {
    private let disposeBag = DisposeBag()
    
    // Input
    private let inputSearchDropDownButtonTapped = PublishSubject<Void>()
    private let inputSelectedDropDownItem = BehaviorSubject<String>(value: "제목")
    private let inputSearchTextField = PublishSubject<String>()
    private let inputSearchEditingDidEnd = PublishSubject<Void>()
    
    // Output
    private let outputDropDownButtonTapped = PublishRelay<[String]>()
    private let outputSearchResult = PublishRelay<[Book]>()
    private let outputSearchResultItem = PublishRelay<[Item]>()
    private let outputSearchError = PublishRelay<SearchError>()
    
    init() {
        setUpDropDownButton()
        trySearchBook()
    }
    
    private func setUpDropDownButton() {
        inputSearchDropDownButtonTapped
            .map {["제목", "저자명", "출판사"]}
            .bind(to: outputDropDownButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func trySearchBook() {
        let dropDownTypeMapping: [String: String] = [
            "제목": "Title",
            "저자명": "Author",
            "출판사": "Publisher"
        ]
        
        inputSearchEditingDidEnd
            .withLatestFrom(Observable.combineLatest(inputSelectedDropDownItem, inputSearchTextField))
            .flatMap { type, title -> Observable<Book> in
                return self.tryGetBook(type: type, title: title, mapping: dropDownTypeMapping)
            }
            .subscribe(onNext: { result in
                self.handleSearchResult(result)
            })
            .disposed(by: disposeBag)
    }
    
    private func tryGetBook(type: String, title: String, mapping: [String: String]) -> Observable<Book> {
        guard !title.isEmpty else {
            self.outputSearchError.accept(.emptySearchText)
            return Observable.empty()
        }
        
        guard let modifiedType = mapping[type] else {
            return Observable.empty()
        }
        
        return BookRepository.shared.getBookSearchData(title: title, type: modifiedType)
            .asObservable()
            .catch { error in
                return Observable.empty()
            }
    }

    private func handleSearchResult(_ result: Book) {
        if result.totalResults == 0 {
            self.outputSearchError.accept(.noResults)
        } else {
            self.outputSearchResult.accept([result])
            self.outputSearchResultItem.accept(result.item)
        }
    }
}

extension SearchViewModel: SearchViewModelType {
    // Input
    var searchDropDownButtonTapped: AnyObserver<Void> {
        inputSearchDropDownButtonTapped.asObserver()
    }
    
    var whichSelectedDropDownItem: AnyObserver<String> {
        inputSelectedDropDownItem.asObserver()
    }
    
    var searchTextFieldInputTextValue: AnyObserver<String> {
        inputSearchTextField.asObserver()
    }
    
    var searchEditingDidEnd: AnyObserver<Void> {
        inputSearchEditingDidEnd.asObserver()
    }
    
    // Output
    var resultDownButtonTapped: Driver<[String]> {
        outputDropDownButtonTapped.asDriver(onErrorJustReturn: [])
    }
    
    var resultSearch: Driver<[Book]> {
        outputSearchResult.asDriver(onErrorDriveWith: .empty())
    }
    
    var resultSearchItem: Driver<[Item]> {
        outputSearchResultItem.asDriver(onErrorDriveWith: .empty())
    }
    
    var resultSearchError: Driver<SearchError> {
        outputSearchError.asDriver(onErrorDriveWith: .empty())
    }
}

