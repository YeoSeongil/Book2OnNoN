//
//  InterestedBookRecordViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData

class InterestedBookRecordViewController: BaseViewController {
    private let viewModel: InterestedBookRecordViewModelType
    
    private lazy var interestedBookRecordSummaryView = InterestedBookRecordSummaryView(viewModel: viewModel)
    private lazy var interestedBookRecordContentView = InterestedBookRecordContentView(viewModel: viewModel)
    
    // MARK: UI Components
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: init
    init(viewModel: InterestedBookRecordViewModelType) {
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
        interestedBookRecordContentView.delegate = self
    }
    
    override func setViewController() {
        super.setViewController()
        [interestedBookRecordSummaryView, interestedBookRecordContentView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        interestedBookRecordSummaryView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(200)
        }
        
        interestedBookRecordContentView.snp.makeConstraints {
            $0.top.equalTo(interestedBookRecordSummaryView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(200)
        }
    }
    
    override func setNavigation() {
        super.setNavigation()
        let rightDeleteButton = UIBarButtonItem(customView: deleteButton)
        self.navigationItem.rightBarButtonItem = rightDeleteButton
    }
    
    override func bind() {
        super.bind()
        // Input
        deleteButton.rx.tap
            .bind(to: viewModel.didDeleteButtonTapped)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.resultInterestedBookRecordDeleteProcedureType
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

extension InterestedBookRecordViewController: InterestedBookRecordContentViewDelegate {
    func editInterestedAssessment() {
        let modalViewController = EditInterestedAssessmentViewController(viewModel: viewModel)
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.modalTransitionStyle = .crossDissolve
    
        self.present(modalViewController, animated: true)
    }
    
    func editInterestedRate() {
        let modalViewController = EditInterestedRateViewController(viewModel: viewModel)
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.modalTransitionStyle = .crossDissolve
    
        self.present(modalViewController, animated: true)
    }
    
}
