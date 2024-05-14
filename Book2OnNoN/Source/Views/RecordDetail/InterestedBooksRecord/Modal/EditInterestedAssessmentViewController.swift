//
//  EditInterestedAssessmentViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData

class EditInterestedAssessmentViewController: BaseViewController {
    private let viewModel: InterestedBookRecordViewModelType
    
    // MARK: UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .PrestigeBlue
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    private let modalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "수정하기"
        label.textColor  = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = .Pretendard.semibold
        return label
    }()
    
    private let closeModalButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        return button
    }()
     
    private lazy var interestedAssessmentTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(white: 0, alpha: 0.3)
        textField.textColor = .white
        textField.font = .Pretendard.regular
        textField.layer.cornerRadius = 5
        textField.addLeftViewImage(systemName: "square.and.pencil")
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(white: 0, alpha: 0.3)
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
    }
    
    override func setViewController() {
        super.setViewController()
        view.backgroundColor  = UIColor(white: 0, alpha: 0.5)
        [containerView].forEach {
            view.addSubview($0)
        }
        
        [modalTitleLabel, closeModalButton, interestedAssessmentTextField, saveButton].forEach {
            containerView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        containerView.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(300)
            $0.height.equalTo(250)
        }
        
        modalTitleLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(10)
            $0.horizontalEdges.equalTo(containerView.snp.horizontalEdges).inset(50)
        }
        
        closeModalButton.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
            $0.top.equalTo(containerView.snp.top).offset(10)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-10)
        }
        
        interestedAssessmentTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.centerY.equalTo(containerView.snp.centerY)
            $0.horizontalEdges.equalTo(containerView.snp.horizontalEdges).inset(20)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(containerView.snp.bottom).offset(-10)
            $0.horizontalEdges.equalTo(containerView.snp.horizontalEdges).inset(50)
        }
    }
    
    override func bind() {
        super.bind()
        interestedAssessmentTextField.rx.text.orEmpty
            .map { $0.count <= 25 }
            .subscribe(onNext: { [weak self ] isEditable in
                if !isEditable {
                    self?.interestedAssessmentTextField.text = String(self?.interestedAssessmentTextField.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        closeModalButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // Input
        saveButton.rx.tap
            .bind(to: viewModel.didEditInterestedAssessmentSaveButtonTapped)
            .disposed(by: disposeBag)
        
        interestedAssessmentTextField.rx.text.orEmpty
            .bind(to: viewModel.didEditInterestedAssessmentValue)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.resultInterestedBooksRecordData
            .drive(onNext: { data in
                self.configuration(with: data)
            })
            .disposed(by: disposeBag)
        
        viewModel.resultInterestedBookRecordEditProcedureType
            .drive(onNext: { type in
                switch type {
                case .successEdit:
                    self.showOnlyOkAlert(title: "😄", message: "수정에 성공했어요.", buttonTitle: "확인했어요", handler: { _ in
                        self.dismiss(animated: true)
                    })
                case .failureEdit:
                    self.showOnlyOkAlert(title: "😢", message: "수정에 실패했어요.", buttonTitle: "확인했어요", handler: { _ in
                        self.dismiss(animated: true)
                    })
                }}).disposed(by: disposeBag)
    }
    
    // MARK: Method
    private func configuration(with record: [InterestedReadingBooks]) {
        if let comment = record[0].comment {
            interestedAssessmentTextField.text = comment
        } else {
            interestedAssessmentTextField.text = "관심 한줄평이 없어요."
        }
    }
}
