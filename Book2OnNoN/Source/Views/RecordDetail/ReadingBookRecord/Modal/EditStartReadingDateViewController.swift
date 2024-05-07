//
//  EditStartReadingDateViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData

class EditStartReadingDateViewController: BaseViewController {
    private let viewModel: ReadingBookRecordViewModelType
    
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
    
    private let startReadingBookDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier:  "ko-KR")
        picker.preferredDatePickerStyle = .wheels
        return picker
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
    init(viewModel: ReadingBookRecordViewModelType) {
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
        
        [modalTitleLabel, closeModalButton, startReadingBookDatePicker, saveButton].forEach {
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
        
        startReadingBookDatePicker.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(50)
            $0.bottom.equalTo(containerView.snp.bottom).offset(-50)
            $0.horizontalEdges.equalTo(containerView.snp.horizontalEdges).inset(20)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(containerView.snp.bottom).offset(-10)
            $0.horizontalEdges.equalTo(containerView.snp.horizontalEdges).inset(50)
        }
    }
    
    override func bind() {
        super.bind()
        closeModalButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // Input
        saveButton.rx.tap
            .bind(to: viewModel.didEditStartReadingDateSaveButtonTapped)
            .disposed(by: disposeBag)
        
        startReadingBookDatePicker.rx.date
            .compactMap { [weak self] date in
                return self?.dateFormatter.string(from: date)
            }
            .bind(to: viewModel.didEditStartReadingDateValue)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.resultReadingBooksRecordData
            .drive(onNext: { data in
                let convertDate = self.convertStringToDate(data[0].startReadingDate ?? "")
                self.startReadingBookDatePicker.date = convertDate!
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Method
    private func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.date(from: dateString)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
}
