//
//  SearchDetailViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchDetailViewController: BaseViewController {
    
    private let viewModel: SearchDetailViewModelType
    
    // MARK: UI Components
    private let summaryView = SearchDetailSummaryView()
    private let descriptionView = SearchDetailDescriptionView()
    private lazy var recordButtonView: SearchDetailRecordButtonView = {
       let view = SearchDetailRecordButtonView()
        view.delegate = self
        return view
    }()
    
    // MARK: init
    init(viewModel: SearchDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUp ViewController
    override func setViewController() {
        super.setViewController()
        view.backgroundColor = .black
    }
    
    override func setAddViews() {
        super.setAddViews()
        [summaryView, descriptionView, recordButtonView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        summaryView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(150)
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(summaryView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(100)
        }

        recordButtonView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }
    }
    
    override func bind() {
        super.bind()
        // Output
        viewModel.resultDetailItem
            .drive(onNext: { [weak self] item in
                guard let item = item else { return }
                self?.summaryView.configuration(with: item)
                self?.descriptionView.configuration(with: item)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Method
}

extension SearchDetailViewController: SearchDetailRecordButtonViewDelegate {
    func didTappedRecordFinishedReadingButton() {
        print("버튼1")
    }
    
    func didTappedRecordReadingButton() {
        print("버튼2")
    }
    
    func didrecordInterestedButton() {
        print("버튼3")
    }
    
    
}
