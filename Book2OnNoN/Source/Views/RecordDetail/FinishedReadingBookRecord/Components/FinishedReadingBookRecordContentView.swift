//
//  FinishedReadingBookRecordContentView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Cosmos

protocol FinishedReadingBookRecordContentViewDelegate: AnyObject {
    func editFinishedReadingAssessment()
}

class FinishedReadingBookRecordContentView: UIView {
    
    weak var delegate: FinishedReadingBookRecordContentViewDelegate?
    
    private let disposeBag = DisposeBag()
    private let viewModel: FinishedReadingBookRecordViewModelType

    // MARK: UIComponents
    private let startReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "읽기 시작한 날"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = .Pretendard.semibold
        return label
    }()
    
    private let startReadingDateTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .PrestigeBlue
        label.font = .Pretendard.regular
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private let finishedReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "다 읽은 날"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = .Pretendard.semibold
        return label
    }()
    
    private let finishedReadingDateTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .PrestigeBlue
        label.font = .Pretendard.regular
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private let bookAssessmentLabel: UILabel = {
        let label = UILabel()
        label.text = "나만의 한줄 서평"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = .Pretendard.semibold
        return label
    }()
    
    private let bookAssessmentTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .PrestigeBlue
        label.font = .Pretendard.regular
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
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
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: init
    init(viewModel: FinishedReadingBookRecordViewModelType) {
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
        [startReadingBookLabel, startReadingDateTextLabel, finishedReadingBookLabel, finishedReadingDateTextLabel, bookAssessmentLabel, bookAssessmentTextLabel,  bookRateView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        startReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        startReadingDateTextLabel.snp.makeConstraints {
            $0.top.equalTo(startReadingBookLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        finishedReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(startReadingDateTextLabel.snp.bottom).offset(30)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        finishedReadingDateTextLabel.snp.makeConstraints {
            $0.top.equalTo(finishedReadingBookLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        bookAssessmentLabel.snp.makeConstraints {
            $0.top.equalTo(finishedReadingDateTextLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        bookAssessmentTextLabel.snp.makeConstraints {
            $0.top.equalTo(bookAssessmentLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        bookRateView.snp.makeConstraints {
            $0.top.equalTo(bookAssessmentTextLabel.snp.bottom).offset(15)
            $0.height.equalTo(30)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        bookAssessmentTextLabel.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.editFinishedReadingAssessment()
            })
            .disposed(by: disposeBag)

        // Output
        viewModel.resultFinishedReadingBookRecordData
            .drive(onNext: { record in
                self.configuration(with: record)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Method
    private func configuration(with record: [FinishedReadingBooks]) {
        if let startReadingDate = record[0].startReadingDate, let finishedReadingDate = record[0].finishReadingDate {
            startReadingDateTextLabel.addImageLabel(text: startReadingDate, systemName: "calendar")
            finishedReadingDateTextLabel.addImageLabel(text: finishedReadingDate, systemName: "calendar")
        } else {
            startReadingDateTextLabel.addImageLabel(text: "날짜 기록이 없어요.", systemName: "calendar")
            finishedReadingDateTextLabel.addImageLabel(text: "날짜 기록이 없어요.", systemName: "calendar")
        }
        
        if let comment = record[0].comment {
            bookAssessmentTextLabel.addImageLabel(text: comment, systemName: "square.and.pencil")
        } else {
            bookAssessmentTextLabel.addImageLabel(text: "나만의 한줄평이 없어요.", systemName: "square.and.pencil")
        }
        
        bookRateView.rating = record[0].rating
        bookRateView.text = "\(record[0].rating)점 / 5.0점"
    }
}
