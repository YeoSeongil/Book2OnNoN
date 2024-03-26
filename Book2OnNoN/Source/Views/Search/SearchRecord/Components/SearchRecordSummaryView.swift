//
//  SearchDetailSummaryView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchRecordSummaryView: UIView {
    
    private let disposeBag = DisposeBag()
    private let viewModel: SearchRecordViewModelType
    
    // MARK: UIComponents
    private let recordBookThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let recordBookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard.semibold
        label.numberOfLines = 5
        label.textColor = .white
        return label
    }()
        
    private let recordBookAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard.regular
        label.numberOfLines = 3
        label.textColor = .gray
        return label
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
        [recordBookThumbnailImageView, recordBookTitleLabel, recordBookAuthorLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        recordBookThumbnailImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalToSuperview().inset(10)
            $0.centerY.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        recordBookTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(recordBookAuthorLabel.snp.top).offset(-10)
            $0.leading.equalTo(recordBookThumbnailImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(safeAreaInsets)
        }
        
        recordBookAuthorLabel.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaInsets).inset(10)
            $0.leading.equalTo(recordBookThumbnailImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(safeAreaInsets)
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
        recordBookThumbnailImageView.setImageKingfisher(with: item[0].cover)
        recordBookTitleLabel.text = item[0].title
        recordBookAuthorLabel.text = item[0].author
    }
}
