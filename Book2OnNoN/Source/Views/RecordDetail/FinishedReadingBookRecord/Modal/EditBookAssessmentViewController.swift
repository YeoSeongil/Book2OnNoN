//
//  EditBookAssessmentViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData
import Cosmos

class EditBookAssessmentViewController: BaseViewController {
    private let viewModel: FinishedReadingBookRecordViewModelType
    
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
     
    private lazy var bookAssessmentTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(white: 0, alpha: 0.3)
        textField.textColor = .white
        textField.font = .Pretendard.regular
        textField.layer.cornerRadius = 5
        textField.addLeftViewImage(systemName: "square.and.pencil")
        return textField
    }()
    
    private let bookRateView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .half
        view.settings.filledImage = UIImage(named: "ratingFilledStar")
        view.settings.emptyImage = UIImage(named: "ratingEmptyStar")
        view.settings.starSize = 30
        view.settings.starMargin = 5
        view.text = "2.5점 / 5점"
        view.settings.textColor = .white
        return view
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
    init(viewModel: FinishedReadingBookRecordViewModelType) {
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
        
        [modalTitleLabel, closeModalButton, bookAssessmentTextField, bookRateView, saveButton].forEach {
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
        
        bookAssessmentTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.centerY.equalTo(containerView.snp.centerY).offset(-20)
            $0.horizontalEdges.equalTo(containerView.snp.horizontalEdges).inset(20)
        }        
        
        bookRateView.snp.makeConstraints {
            $0.top.equalTo(bookAssessmentTextField.snp.bottom).offset(15)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(containerView.snp.bottom).offset(-10)
            $0.horizontalEdges.equalTo(containerView.snp.horizontalEdges).inset(50)
        }
    }
    
    override func bind() {
        super.bind()
        bookAssessmentTextField.rx.text.orEmpty
            .map { $0.count <= 25 }
            .subscribe(onNext: { [weak self ] isEditable in
                if !isEditable {
                    self?.bookAssessmentTextField.text = String(self?.bookAssessmentTextField.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        bookRateView.rx.didTouchCosmos
            .onNext { rating in
                self.bookRateView.text = "\(rating)점 / 5.0점"
            }
        
        closeModalButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // Input
        saveButton.rx.tap
            .bind(to: viewModel.didEditBookAssessmentSaveButtonTapped)
            .disposed(by: disposeBag)
        
        bookAssessmentTextField.rx.text.orEmpty
            .bind(to: viewModel.didEditBookAssessmentTextValue)
            .disposed(by: disposeBag)
        
        bookRateView.rx.didFinishTouchingCosmos
            .onNext { rating in
                self.viewModel.didEditBookRateValue.onNext(rating)
            }
        
        // Output
        viewModel.resultFinishedReadingBookRecordData
            .drive(onNext: { data in
                self.configuration(with: data)
            })
            .disposed(by: disposeBag)
        
        viewModel.resultFinishedReadingBookRecordEditProcedureType
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
    private func configuration(with record: [FinishedReadingBooks]) {
        if let comment = record[0].comment {
            bookAssessmentTextField.text = comment
        } else {
            bookAssessmentTextField.text = "관심 한줄평이 없어요."
        }
        
        bookRateView.rating = record[0].rating
        bookRateView.text = "\(record[0].rating)점 / 5.0점"
    }
}
