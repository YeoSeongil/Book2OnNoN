//
//  HomeViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData


// Todo
// User 정보가 없을 때 register 하는 기능 구현
class HomeViewController: BaseViewController {
    private let viewModel: HomeViewModelType
    
    private lazy var  homeReadingBookView = HomeReadingBookView(viewModel: viewModel)
    private lazy var  homeInterestedBookView = HomeInterestedBookView(viewModel: viewModel)
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    init(viewModel: HomeViewModelType = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func setViewController() {
        super.setViewController()
        [homeReadingBookView, homeInterestedBookView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        homeReadingBookView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(300)
        }        
        
        homeInterestedBookView.snp.makeConstraints {
            $0.top.equalTo(homeReadingBookView.snp.bottom).offset(10)
            $0.width.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(170)
        }
    }
    
    override func setNavigation() {
        super.setNavigation()
    
        let rightButton = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = rightButton
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButton.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton
    }
    
    override func bind() {
        searchButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigationController?.pushViewController(SearchViewController(), animated: true)
            }).disposed(by: disposeBag)
    }
}
