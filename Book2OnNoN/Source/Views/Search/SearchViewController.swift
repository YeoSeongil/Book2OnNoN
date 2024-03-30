//
//  SearchViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DropDown

class SearchViewController: BaseViewController {
    
    private let viewModel: SearchViewModelType
    
    // MARK: UI Components
    private lazy var searchTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-120, height: 30))
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .BlackPearl
        textField.font = .Pretendard.medium
        textField.textColor = .white
        return textField
    }()
    
    private lazy var searchDropDownButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        button.setTitle("제목", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.semibold
        button.tintColor = .white
        return button
    }()
    
    private lazy var searchOptionDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = searchDropDownButton
        return dropDown
    }()
    
    private lazy var searchResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.id)
        tableView.backgroundColor = .black
        return tableView
    }()
    
    // MARK: init
    init(viewModel: SearchViewModelType = SearchViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUp ViewController
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    override func setViewController() {
        super.setViewController()
    }
    
    override func setAddViews() {
        [searchResultTableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
    }
    
    override func setNavigation() {
        navigationController?.navigationBar.barTintColor = .black
        tabBarController?.tabBar.barTintColor = .black
        let searchDropDownBarButtonItem = UIBarButtonItem(customView: searchDropDownButton)
        let searchTextFieldBarButtonItem = UIBarButtonItem(customView: searchTextField)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButton.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.rightBarButtonItems = [searchDropDownBarButtonItem, searchTextFieldBarButtonItem]
    }
    
    override func bind() {
        searchResultTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // Input
        searchDropDownButton.rx.tap
            .asObservable()
            .bind(to: viewModel.searchDropDownButtonTapped)
            .disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .asObservable()
            .bind(to: viewModel.searchTextFieldInputTextValue)
            .disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .bind(to: viewModel.searchEditingDidEnd)
            .disposed(by: disposeBag)
        
        searchOptionDropDown.rx.selectionAction.onNext { [weak self] index, item in
            self?.searchDropDownButton.setTitle(item, for: .normal)
            self?.viewModel.whichSelectedDropDownItem.onNext(item)
        }
        
        searchResultTableView.rx.modelSelected(Item.self)
            .bind(onNext: { [weak self] item in
                let recordViewModel = SearchRecordViewModel(item: item)
                let recordViewController = SearchRecordViewController(viewModel: recordViewModel)
                self?.navigationController?.pushViewController(recordViewController, animated: true)
            }).disposed(by: disposeBag)
        
        searchResultTableView.rx.didScroll
            .asObservable()
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .map { self.isNearBottomEdge() }
            .bind(to: viewModel.isSearchResultTableViewisNearBottomEdge)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.resultDownButtonTapped
            .drive(onNext: {[weak self] data in
                self?.searchOptionDropDown.show()
                self?.searchOptionDropDown.dataSource = data
            }).disposed(by: disposeBag)
        
        viewModel.resultSearchItem
            .drive(searchResultTableView.rx.items(cellIdentifier: SearchResultTableViewCell.id, cellType: SearchResultTableViewCell.self)) { row, item, cell in
                cell.configuration(book: item)
            }.disposed(by: disposeBag)
        
        viewModel.resultSearchError
            .drive(onNext: { err in
                switch err {
                case .emptySearchText:
                    self.searchTextField.shakeAnimation()
                case .noResults:
                    self.showOnlyOkAlert(title: "😢", message: "검색 결과가 없습니다.", buttonTitle: "확인했어요")
                    self.searchTextField.text = .none
                }
            }).disposed(by: disposeBag)
    }
    
    private func showDropDown() {
        searchOptionDropDown.show()
    }
    
    private func isNearBottomEdge() -> Bool {
        guard self.searchResultTableView.contentSize.height > 0 else {
            return false
        }
        return self.searchResultTableView.contentOffset.y + self.searchResultTableView.bounds.size.height + 1.0 >= self.searchResultTableView.contentSize.height
    }

}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100.0)
    }
}

