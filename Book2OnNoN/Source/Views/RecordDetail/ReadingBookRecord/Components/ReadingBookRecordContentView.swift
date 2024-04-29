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
    private let readingBookStartReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "읽기 시작한 날"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = .Pretendard.semibold
        return label
    }()   
    
    private lazy var readingBookDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .PrestigeBlue
        textField.textColor = .white
        textField.tintColor = .clear
        textField.font = .Pretendard.regular
        textField.layer.cornerRadius = 5
        textField.inputView = readingBookDatePicker
        
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
    
    private let readingBookDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier:  "ko-KR")
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    private let readingBookAmountOfReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "독서량"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = .Pretendard.semibold
        return label
    }()

    private lazy var readingBookAmountOfReadingBookTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .PrestigeBlue
        textField.textColor = .white
        textField.tintColor = .clear
        textField.font = .Pretendard.regular
        textField.layer.cornerRadius = 5
        textField.inputView = readingBookAmountOfReadingBookPicker
        
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
    
    private let readingBookAmountOfReadingBookPicker: UIPickerView = {
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
        [readingBookStartReadingBookLabel, readingBookDateTextField, readingBookAmountOfReadingBookLabel, readingBookAmountOfReadingBookTextField].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        readingBookStartReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        readingBookDateTextField.snp.makeConstraints {
            $0.top.equalTo(readingBookStartReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        readingBookAmountOfReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(readingBookDateTextField.snp.bottom).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        readingBookAmountOfReadingBookTextField.snp.makeConstraints {
            $0.top.equalTo(readingBookAmountOfReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
    }
    
    private func bind() {
        readingBookDatePicker.rx.date
            .map { [weak self] in
                self?.dateFormatter.string(from: $0)
            }
            .bind(to: readingBookDateTextField.rx.text)
            .disposed(by: disposeBag)
        
        readingBookAmountOfReadingBookPicker.rx.itemSelected
            .subscribe(onNext: { index  in
                self.readingBookAmountOfReadingBookTextField.text = "\(index.row + 1) 쪽"
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
                    .bind(to: self.readingBookAmountOfReadingBookPicker.rx.itemTitles) { _ , item in
                        return "\(item)"
                    }.disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    // MARK: Method
    private func configuration(with record: [ReadingBooks]) {
        readingBookAmountOfReadingBookTextField.text = record[0].readingPage
        readingBookDateTextField.text = record[0].startReadingDate
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
}
