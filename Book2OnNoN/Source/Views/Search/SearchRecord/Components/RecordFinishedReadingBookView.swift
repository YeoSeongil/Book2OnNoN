//
//  RecordFinishedReadingBookView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Cosmos

class RecordFinishedReadingBookView: UIScrollView {
    
    private let disposeBag = DisposeBag()
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    // MARK: UIComponents
    
    private let startReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "읽기 시작한 날"
        label.textColor = .white
        label.font = .Pretendard.semibold
        return label
    }()
    
    private lazy var startReadingBookDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .PrestigeBlue
        textField.textColor = .white
        textField.font = .Pretendard.regular
        textField.layer.cornerRadius = 5
        textField.inputView = startReadingBookDatePicker
        
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        leftViewContainer.addSubview(imageView)
        imageView.frame = leftViewContainer.bounds
        textField.leftView = leftViewContainer
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let startReadingBookDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier:  "ko-KR")
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    private let finishReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "다 읽은 날"
        label.textColor = .white
        label.font = .Pretendard.semibold
        return label
    }()
    
    private lazy var finishReadingBookDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .PrestigeBlue
        textField.layer.cornerRadius = 5
        textField.textColor = .white
        textField.tintColor = .clear
        textField.font = .Pretendard.regular
        textField.inputView = finishReadingBookDatePicker
        
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        leftViewContainer.addSubview(imageView)
        imageView.frame = leftViewContainer.bounds
        textField.leftView = leftViewContainer
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let finishReadingBookDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier:  "ko-KR")
        picker.preferredDatePickerStyle = .wheels
        picker.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        return picker
    }()
    
    private let bookAssessmentLabel: UILabel = {
        let label = UILabel()
        label.text = "나만의 한줄 서평"
        label.textColor = .white
        label.font = .Pretendard.semibold
        return label
    }()
    
    private lazy var bookAssessmentTextField: UITextField = {
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
    
    private let bookRatingView: CosmosView = {
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
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConfiguration()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set View
    private func setView() {
        addSubview(contentView)
        [startReadingBookLabel, startReadingBookDateTextField, finishReadingBookLabel, finishReadingBookDateTextField, bookAssessmentLabel, bookAssessmentTextField, bookRatingView].forEach {
            contentView.addSubview($0)
        }
        
        alwaysBounceVertical = true
    }
    
    private func setConfiguration() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().offset(75)
        }
        
        startReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
        }
        
        startReadingBookDateTextField.snp.makeConstraints {
            $0.top.equalTo(startReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.height.equalTo(30)
        }
        
        finishReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(startReadingBookDateTextField.snp.bottom).offset(5)
            $0.leading.equalTo(contentView.snp.leading)
        }
        
        finishReadingBookDateTextField.snp.makeConstraints {
            $0.top.equalTo(finishReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.height.equalTo(30)
        }
        
        bookAssessmentLabel.snp.makeConstraints {
            $0.top.equalTo(finishReadingBookDateTextField.snp.bottom).offset(20)
            $0.leading.equalTo(contentView.snp.leading)
        }
        
        bookAssessmentTextField.snp.makeConstraints {
            $0.top.equalTo(bookAssessmentLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.height.equalTo(30)
        }
        
        bookRatingView.snp.makeConstraints {
            $0.top.equalTo(bookAssessmentTextField.snp.bottom).offset(15)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    private func bind() {
        startReadingBookDatePicker.rx.date
            .map { [weak self] in
                self?.dateFormatter.string(from: $0)
            }
            .bind(to: startReadingBookDateTextField.rx.text)
            .disposed(by: disposeBag)
        
        finishReadingBookDatePicker.rx.date
            .map { [weak self] in
                self?.dateFormatter.string(from: $0)
            }
            .bind(to: finishReadingBookDateTextField.rx.text)
            .disposed(by: disposeBag)
        
        bookRatingView.rx.didTouchCosmos
            .onNext { rating in
                self.bookRatingView.text = "\(rating)점 / 5.0점"
            }
    }
    
    // MARK: Method
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
}
