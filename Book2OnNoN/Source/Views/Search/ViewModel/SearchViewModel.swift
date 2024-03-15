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
    var isSearchResultTableViewisNearBottomEdge: AnyObserver<Bool> { get } // resultTableView가 하단에 닿았는지 옵저빙
    
    // Output
    var resultDownButtonTapped: Driver<[String]> { get }
    var resultSearch: Driver<[Book]> { get }
    var resultSearchItem: Driver<[Item]> { get }
    var resultSearchError: Driver<SearchError> { get }
}

class SearchViewModel {
    private let disposeBag = DisposeBag()
    
    private var currentPage = 1
    
    // Input
    private let inputSearchDropDownButtonTapped = PublishSubject<Void>()
    private let inputSelectedDropDownItem = BehaviorSubject<String>(value: "제목")
    private let inputSearchTextField = PublishSubject<String>()
    private let inputSearchEditingDidEnd = PublishSubject<Void>()
    private let inputIsSearchResultTableViewisNearBottomEdge = PublishSubject<Bool>()
    
    // Output
    private let outputDropDownButtonTapped = PublishRelay<[String]>()
    private let outputSearchResult = BehaviorRelay<[Book]>(value: [])
    private let outputSearchResultItem = BehaviorRelay<[Item]>(value: [])
    private let outputSearchError = PublishRelay<SearchError>()
    
    init() {
        setUpDropDownButton()
        trySearchBook()
        tryScrollSearch()
    }
    
    private func setUpDropDownButton() {
        inputSearchDropDownButtonTapped
            .map {["제목", "저자명", "출판사"]}
            .bind(to: outputDropDownButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func trySearchBook() {
        inputSearchEditingDidEnd
            .withLatestFrom(Observable.combineLatest(inputSelectedDropDownItem, inputSearchTextField))
            .flatMap { type, title -> Observable<Book> in
                return self.tryGetBook(type: type, title: title,  page: 1)
            }
            .subscribe(onNext: { result in
                self.handleSearchResult(result)
            })
            .disposed(by: disposeBag)
    }
    
    private func tryScrollSearch() {
        inputIsSearchResultTableViewisNearBottomEdge
            .filter { $0 }
            .withLatestFrom(Observable.combineLatest(inputSelectedDropDownItem, inputSearchTextField))
            .flatMap { [weak self] type, title -> Observable<(Int, Book)> in
                guard let self = self else { return Observable.empty() }
                let nextPage = self.currentPage + 1
                return self.tryGetBook(type: type, title: title, page: nextPage)
                    .map { (nextPage, $0) }
            }
            .subscribe(onNext: { [weak self] page, books in
                guard let self = self else { return }
                self.currentPage = page
                self.outputSearchResultItem.accept(self.outputSearchResultItem.value + books.item)
            })
            .disposed(by: disposeBag)
    }
    
    private func tryGetBook(type: String, title: String, page: Int) -> Observable<Book> {
        let dropDownTypeMapping: [String: String] = [
            "제목": "Title",
            "저자명": "Author",
            "출판사": "Publisher"
        ]
        
        guard !title.isEmpty else {
            self.outputSearchError.accept(.emptySearchText)
            return Observable.empty()
        }
    
        guard let modifiedType = dropDownTypeMapping[type] else {
            return Observable.empty()
        }
        
        return BookRepository.shared.getBookSearchData(title: title, type: modifiedType, page: page )
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
    
    var isSearchResultTableViewisNearBottomEdge: AnyObserver<Bool> {
        inputIsSearchResultTableViewisNearBottomEdge.asObserver()
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

