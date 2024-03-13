//
//  SearchViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/11/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchViewModelType {
    // Input
    var searchDropDownButtonTapped: AnyObserver<Void> { get } // SearchDropDown Button이 Tapped 되었는지 옵저빙
    var searchTextFieldInputTextValue: AnyObserver<String> { get } // SearchTextField에 입력 된 Text Value를 옵저빙
    var searchEditingDidEnd: AnyObserver<Void> { get } // Search TextField의 입력이 끝났는지 옵저빙
    var whichSelectedDropDownItem: AnyObserver<String> { get } // 어떤 DropDownItem이 선택 되었는지 옵저빙
    
    // Output
    var resultDownButtonTapped: Driver<[String]> { get }
    var resultSearch: Driver<Book> { get }
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
    private let outputSearchResult = PublishRelay<Book>()
    
    init() {
        setUpDropDownButton()
        trySearchBook()
    }
    
    private func setUpDropDownButton() {
        inputSearchDropDownButtonTapped
            .map {["제목", "저자명", "출판사", "ISBN"]}
            .bind(to: outputDropDownButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func trySearchBook() {
        inputSearchEditingDidEnd
            .withLatestFrom(Observable.combineLatest(inputSelectedDropDownItem, inputSearchTextField))
            .flatMap { type, title in
                return BookRepository.shared.getBookSearchData(title: title, type: type)
                    .asObservable()
                    .catch { error in
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { result in
                self.outputSearchResult.accept(result)
            })
            .disposed(by: disposeBag)
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
    
    var resultSearch: Driver<Book> {
        outputSearchResult.asDriver(onErrorDriveWith: .empty())
    }
}

