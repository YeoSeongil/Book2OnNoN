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
    
    private lazy var startReadingBookTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .PrestigeBlue
        label.font = .Pretendard.regular
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.addImageLabel(text: "테스트", systemName: "calendar")
        return label
    }()

    private let amountOfReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "독서량"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = .Pretendard.semibold
        return label
    }()

    private lazy var amountOfReadingBookTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .PrestigeBlue
        label.font = .Pretendard.regular
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.addImageLabel(text: "테스트", systemName: "book")
        return label
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
        [startReadingBookLabel, startReadingBookTextLabel, amountOfReadingBookLabel, amountOfReadingBookTextLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        startReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        startReadingBookTextLabel.snp.makeConstraints {
            $0.top.equalTo(startReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        amountOfReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(startReadingBookTextLabel.snp.bottom).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        amountOfReadingBookTextLabel.snp.makeConstraints {
            $0.top.equalTo(amountOfReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
    }
    
    private func bind() {
        // Output
        viewModel.resultReadingBooksRecordData
            .drive(onNext: { record in
                self.configuration(with: record)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Method
    private func configuration(with record: [ReadingBooks]) {
        startReadingBookTextLabel.addImageLabel(text: record[0].startReadingDate!, systemName: "calendar")
        amountOfReadingBookTextLabel.addImageLabel(text: record[0].readingPage!, systemName: "book")
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
}
