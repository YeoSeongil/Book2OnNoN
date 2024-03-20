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


class RecordFinishedReadingBookView: UIView {
    
    private let disposeBag = DisposeBag()
    
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
        textField.font = .Pretendard.regular
        textField.inputView = finishReadingBookDatePicker
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
        [startReadingBookLabel, startReadingBookDateTextField, finishReadingBookLabel, finishReadingBookDateTextField].forEach {
            addSubview($0)
        }
    }
    
    private func setConfiguration() {
        startReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        startReadingBookDateTextField.snp.makeConstraints {
            $0.top.equalTo(startReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        finishReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(startReadingBookDateTextField.snp.bottom).offset(5)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        finishReadingBookDateTextField.snp.makeConstraints {
            $0.top.equalTo(finishReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
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
