//
//  SearchDetailDescriptionView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class SearchRecordDescriptionView: UIView {

    private let disposeBag = DisposeBag()
    private let viewModel: SearchRecordViewModelType
    
    // MARK: UIComponents
    private let recordBookDescriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "줄거리"
        label.font = .Pretendard.semibold
        label.textColor = .white
        return label
    }()
    
    private let recordBookDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .Pretendard.regular
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()

    // MARK: init
    init(viewModel: SearchRecordViewModelType) {
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
        [recordBookDescriptionTitleLabel, recordBookDescriptionTextView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        recordBookDescriptionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        recordBookDescriptionTextView.snp.makeConstraints {
            $0.top.equalTo(recordBookDescriptionTitleLabel.snp.bottom)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        viewModel.resultLookUpItem
            .drive(onNext: { item in
                self.configuration(with: item)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Method
    private func configuration(with item: [LookUpItem]) {
        recordBookDescriptionTextView.text = item[0].description
    }
}
