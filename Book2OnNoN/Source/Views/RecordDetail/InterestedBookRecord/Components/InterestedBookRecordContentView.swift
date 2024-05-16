//
//  InterestedBookContentView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Cosmos

protocol InterestedBookRecordContentViewDelegate: AnyObject {
    func editInterestedAssessment()
    func editInterestedRate()
}

class InterestedBookRecordContentView: UIView {
    weak var delegate: InterestedBookRecordContentViewDelegate?
    
    private let disposeBag = DisposeBag()
    private let viewModel: InterestedBookRecordViewModelType

    
    // MARK: UIComponents
    private let interestedAssessmentLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 한줄평"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = .Pretendard.semibold
        return label
    }()
    
    private let interestedAssessmentTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .PrestigeBlue
        label.font = .Pretendard.regular
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()

    private let interestedRateLabel: UILabel = {
        let label = UILabel()
        label.text = "관심지수"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = .Pretendard.semibold
        return label
    }()
    
    private let interestedRatingEditButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return button
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
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: init
    init(viewModel: InterestedBookRecordViewModelType) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setView()
        setConstraints()
        bind()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set View
    private func setView() {
        [interestedAssessmentLabel, interestedAssessmentTextLabel, interestedRateLabel, interestedRatingEditButton, interestedRateView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        interestedAssessmentLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        interestedAssessmentTextLabel.snp.makeConstraints {
            $0.top.equalTo(interestedAssessmentLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        interestedRateLabel.snp.makeConstraints {
            $0.top.equalTo(interestedAssessmentTextLabel.snp.bottom).offset(30)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }        
        
        interestedRatingEditButton.snp.makeConstraints {
            $0.top.equalTo(interestedAssessmentTextLabel.snp.bottom).offset(30)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
            $0.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        interestedRateView.snp.makeConstraints {
            $0.top.equalTo(interestedRateLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
    }
    
    private func bind() {
        interestedAssessmentTextLabel.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.editInterestedAssessment()
            })
            .disposed(by: disposeBag)
        
        interestedRatingEditButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.editInterestedRate()
            })
            .disposed(by: disposeBag)
        
        // Input
        
        // Output
        viewModel.resultInterestedBooksRecordData
            .drive(onNext: { record in
                self.configuration(with: record)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Method
    private func configuration(with record: [InterestedReadingBooks]) {
        if let comment = record[0].comment {
            interestedAssessmentTextLabel.addImageLabel(text: comment, systemName: "square.and.pencil")
        } else {
            interestedAssessmentTextLabel.addImageLabel(text: "관심 한줄평이 없어요.", systemName: "square.and.pencil")
        }
        
        interestedRateView.rating = record[0].rating
        interestedRateView.text = "\(record[0].rating)점 / 5.0점"
    }
}
