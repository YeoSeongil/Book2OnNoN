//
//  EditAmountOfReadingBookViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData

class EditAmountOfReadingBookViewController: BaseViewController {
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
    
    private let amountOfReadingBookPicker: UIPickerView = {
        let picker = UIPickerView()
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
    
    override func setViewController() {
        super.setViewController()
        view.backgroundColor  = UIColor(white: 0, alpha: 0.5)
        [containerView].forEach {
            view.addSubview($0)
        }
        
        [modalTitleLabel, closeModalButton, amountOfReadingBookPicker, saveButton].forEach {
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
        
        amountOfReadingBookPicker.snp.makeConstraints {
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
            .bind(to: viewModel.didEditAmountOfReadingBookSaveButtonTapped)
            .disposed(by: disposeBag)
        
        amountOfReadingBookPicker.rx.modelSelected(Int.self)
            .map { selectRows in return selectRows.first ?? 1 }
            .bind(to: viewModel.didEditAmountOfReadingBookValue)
            .disposed(by: disposeBag)
    
        // Output
        viewModel.resultReadingBookLookUpItem
            .drive(onNext: { item in
                Observable.just(Array(1...item[0].subInfo.itemPage))
                    .bind(to: self.amountOfReadingBookPicker.rx.itemTitles) { _ , item in
                        return "\(item)"
                    }.disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        viewModel.resultReadingBooksRecordData
            .drive(onNext: { data in
                var rowIndex: Int
                
                if data[0].readingPage == 1 {
                    rowIndex = 1
                } else {
                    rowIndex = Int(data[0].readingPage - 1)
                }
                
                self.amountOfReadingBookPicker.selectRow(rowIndex, inComponent: 0, animated: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.resultReadingBookRecordEditProcedureType
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
}
