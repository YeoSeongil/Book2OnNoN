//
//  RecordInterestedBookView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Cosmos

class RecordInterestedBookView: UIView {
    
    private let disposeBag = DisposeBag()
    private let viewModel: SearchRecordViewModelType
    
    // MARK: UIComponents
    private let interestedAssessmentLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 한줄평"
        label.textColor = .white
        label.font = .Pretendard.semibold
        return label
    }()
    
    private lazy var interestedAssessmentTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .PrestigeBlue
        textField.textColor = .white
        textField.font = .Pretendard.regular
        textField.layer.cornerRadius = 5
        
        let imageView = UIImageView(image: UIImage(systemName: "square.and.pencil"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        leftViewContainer.addSubview(imageView)
        imageView.frame = leftViewContainer.bounds
        textField.leftView = leftViewContainer
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let interestedRateLabel: UILabel = {
        let label = UILabel()
        label.text = "관심지수"
        label.textColor = .white
        label.font = .Pretendard.semibold
        return label
    }()
    
    private let interestedRateView: CosmosView = {
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
    
    private lazy var accessoryLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        label.backgroundColor = .PrestigeBlue
        label.font = .Pretendard.medium
        label.textColor = .white
        return label
    }()
    
    init(viewModel: SearchRecordViewModelType) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setView()
        setConfiguration()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        [interestedAssessmentLabel, interestedAssessmentTextField, interestedRateLabel, interestedRateView].forEach {
            addSubview($0)
        }
    }
    
    private func setConfiguration() {
        interestedAssessmentLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        interestedAssessmentTextField.snp.makeConstraints {
            $0.top.equalTo(interestedAssessmentLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        interestedRateLabel.snp.makeConstraints {
            $0.top.equalTo(interestedAssessmentTextField.snp.bottom).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        interestedRateView.snp.makeConstraints {
            $0.top.equalTo(interestedRateLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
    }
    
    private func bind() {
        interestedRateView.rx.didTouchCosmos
            .onNext { rating in
                self.interestedRateView.text = "\(rating)점 / 5.0점"
            }
        
        interestedAssessmentTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in
                self?.interestedAssessmentTextField.inputAccessoryView = self?.accessoryLabel
            })
            .disposed(by: disposeBag)
        
        interestedAssessmentTextField.rx.text.orEmpty
            .map { $0.count <= 25 }
            .subscribe(onNext: { [weak self ] isEditable in
                if !isEditable {
                    self?.interestedAssessmentTextField.text = String(self?.interestedAssessmentTextField.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        interestedAssessmentTextField.rx.text.orEmpty
            .bind(to: accessoryLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
