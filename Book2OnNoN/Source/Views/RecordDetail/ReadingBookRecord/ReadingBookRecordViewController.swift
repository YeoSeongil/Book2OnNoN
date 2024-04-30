//
//  ReadingBookRecrodViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData

class ReadingBookRecordViewController: BaseViewController {
    private let viewModel: ReadingBookRecordViewModelType
    
    private lazy var readingBookRecordSummaryView = ReadingBookRecordSummaryView(viewModel: viewModel)
    private lazy var readingBookRecordContentView = ReadingBookRecordContentView(viewModel: viewModel)
    
    // MARK: UI Components
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .white
        return button
    }()   
    
    private let modifyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .white
        button.addAction(UIAction { _ in
        }, for: .touchUpInside)
        return button
    }()
    
    // MARK: init
    init(viewModel: ReadingBookRecordViewModelType) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setViewController() {
        super.setViewController()
        [readingBookRecordSummaryView, readingBookRecordContentView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        readingBookRecordSummaryView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(200)
        }        
        
        readingBookRecordContentView.snp.makeConstraints {
            $0.top.equalTo(readingBookRecordSummaryView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(200)
        }
    }
    
    override func setNavigation() {
        super.setNavigation()
        let rightDeleteButton = UIBarButtonItem(customView: deleteButton)
        let rightModifyButton = UIBarButtonItem(customView: modifyButton)
        self.navigationItem.rightBarButtonItems = [rightDeleteButton, rightModifyButton]
    }
    
    override func bind() {
        super.bind()
        
        // Input
        deleteButton.rx.tap
            .bind(to: viewModel.didDeleteButtonTapped)
            .disposed(by: disposeBag)
        
        modifyButton.rx.tap
            .bind(to: viewModel.didModifyButtonTapped)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.resultReadingBookRecordDeleteProcedureType
            .drive(onNext: { type in
                switch type {
                case .successDelete:
                    self.showOnlyOkAlert(title: "😄", message: "삭제에 성공했어요.", buttonTitle: "확인했어요", handler: { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                case .failureDelete:
                    self.showOnlyOkAlert(title: "😢", message: "저장에 실패했어요.", buttonTitle: "확인했어요", handler: .none)
                }
            })
            .disposed(by: disposeBag)
    }
}
