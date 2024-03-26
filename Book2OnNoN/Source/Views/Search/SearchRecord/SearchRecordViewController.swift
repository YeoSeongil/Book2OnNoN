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

class SearchRecordViewController: BaseViewController {
    
    private let viewModel: SearchRecordViewModelType
    
    // MARK: UI Components
    private let recordSaveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.semibold
        return button
    }()
    
    private lazy var  summaryView = SearchRecordSummaryView(viewModel: viewModel)
    private lazy var  descriptionView = SearchRecordDescriptionView(viewModel: viewModel)
    private lazy var recordButtonView: SearchDetailRecordButtonView = {
        let view = SearchDetailRecordButtonView()
        view.delegate = self
        return view
    }()
    private lazy var recordFinishedView: RecordFinishedReadingBookView = {
        let view = RecordFinishedReadingBookView(viewModel: viewModel)
        view.isHidden = false
        return view
    }()
    private lazy var recordReadingView: RecordReadingBookView = {
        let view = RecordReadingBookView(viewModel: viewModel)
        view.isHidden = true
        return view
    }()
    
    private lazy var recordInterestView: RecordInterestedBookView = {
        let view = RecordInterestedBookView()
        view.isHidden = true
        return view
    }()

    // MARK: init
    init(viewModel: SearchRecordViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUp ViewController
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setViewController() {
        super.setViewController()
        view.backgroundColor = .black
    }
    
    override func setNavigation() {
        let rightButton = UIBarButtonItem(customView: recordSaveButton)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    override func setAddViews() {
        super.setAddViews()
        [summaryView, descriptionView, recordButtonView, recordFinishedView, recordReadingView, recordInterestView ].forEach {
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
            $0.top.equalTo(summaryView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(120)
        }

        recordButtonView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }
        
        recordFinishedView.snp.makeConstraints {
            $0.top.equalTo(recordButtonView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(1)
        }
        
        recordReadingView.snp.makeConstraints {
            $0.top.equalTo(recordButtonView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }        
        
        recordInterestView.snp.makeConstraints {
            $0.top.equalTo(recordButtonView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bind() {
        super.bind()
        recordSaveButton.rx.tap
            .bind(to: viewModel.didRecordSaveButtonTapped)
            .disposed(by: disposeBag)
        // Input
        
        // Output
    }
    
    // MARK: Method
}

extension SearchRecordViewController: SearchRecordButtonViewDelegate {
    func didTapRecordButton(type: RecordButtonType) {
        switch type {
        case .finishedReading:
            viewModel.didRecordButtonTapped.onNext("finish")
            recordFinishedView.isHidden = false
            recordReadingView.isHidden = true
            recordInterestView.isHidden = true
        case .reading:
            viewModel.didRecordButtonTapped.onNext("reading")
            recordFinishedView.isHidden = true
            recordReadingView.isHidden = false
            recordInterestView.isHidden = true
            self.view.endEditing(true)
        case .interested:
            viewModel.didRecordButtonTapped.onNext("interested")
            recordFinishedView.isHidden = true
            recordReadingView.isHidden = true
            recordInterestView.isHidden = false
            self.view.endEditing(true)
        }
    }

}
