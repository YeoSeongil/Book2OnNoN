//
//  ReadingBookRecordContentView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Charts

class ReadingBookRecordContentView: UIView {
    
    private let disposeBag = DisposeBag()
    private let viewModel: ReadingBookRecordViewModelType
    
     //private var amountOfReadingBookBarCharView: BarChartView!
    
    // MARK: UIComponents
    private let startReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "읽기 시작한 날"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = .Pretendard.semibold
        return label
    }()
    
    private lazy var startReadingBookDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .PrestigeBlue
        textField.textColor = .white
        textField.tintColor = .clear
        textField.font = .Pretendard.regular
        textField.layer.cornerRadius = 5
        textField.inputView = readingBookDatePicker
        textField.addLeftViewImage(systemName: "calendar")
        
        return textField
    }()
    
    private let readingBookDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier:  "ko-KR")
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    private let amountOfReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "독서량"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = .Pretendard.semibold
        return label
    }()

    private lazy var amountOfReadingBookTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .PrestigeBlue
        textField.textColor = .white
        textField.tintColor = .clear
        textField.font = .Pretendard.regular
        textField.layer.cornerRadius = 5
        textField.inputView = amountOfReadingBookPicker
        
        let imageView = UIImageView(image: UIImage(systemName: "book"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        leftViewContainer.addSubview(imageView)
        imageView.frame = leftViewContainer.bounds
        textField.leftView = leftViewContainer
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let amountOfReadingBookPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    // MARK: init
    init(viewModel: ReadingBookRecordViewModelType) {
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
        [startReadingBookLabel, startReadingBookDateTextField, amountOfReadingBookLabel, amountOfReadingBookTextField].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        startReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        startReadingBookDateTextField.snp.makeConstraints {
            $0.top.equalTo(startReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        amountOfReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(startReadingBookDateTextField.snp.bottom).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        amountOfReadingBookTextField.snp.makeConstraints {
            $0.top.equalTo(amountOfReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
    }
    
    private func bind() {
        readingBookDatePicker.rx.date
            .map { [weak self] in
                self?.dateFormatter.string(from: $0)
            }
            .bind(to: startReadingBookDateTextField.rx.text)
            .disposed(by: disposeBag)
        
        amountOfReadingBookPicker.rx.itemSelected
            .subscribe(onNext: { index  in
                self.amountOfReadingBookTextField.text = "\(index.row + 1) 쪽"
            }).disposed(by: disposeBag)
        
        // Output
        viewModel.resultReadingBooksRecordData
            .drive(onNext: { record in
                self.configuration(with: record)
            })
            .disposed(by: disposeBag)
        
        viewModel.resultReadingBookLookUpItem
            .drive(onNext: { item in
                Observable.just(Array(1...item[0].subInfo.itemPage))
                    .bind(to: self.amountOfReadingBookPicker.rx.itemTitles) { _ , item in
                        return "\(item)"
                    }.disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    // MARK: Method
    private func configuration(with record: [ReadingBooks]) {
        startReadingBookDateTextField.text = record[0].startReadingDate
        amountOfReadingBookTextField.text = record[0].readingPage
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
}
