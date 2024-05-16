//
//  InterestedBookRecordSummaryView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/13/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class InterestedBookRecordSummaryView: UIView {
    
    private let disposeBag = DisposeBag()
    private let viewModel: InterestedBookRecordViewModelType
    
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
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    // MARK: init
    init(viewModel: InterestedBookRecordViewModelType) {
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
        [recordBookThumbnailImageView, recordBookTitleLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        recordBookThumbnailImageView.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview().inset(50)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        recordBookTitleLabel.snp.makeConstraints {
            $0.top.equalTo(recordBookThumbnailImageView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }
    
    private func bind() {
        // Output
        viewModel.resultInterestedBooksRecordData
            .drive(onNext: { record in
                self.configuration(with: record)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Method
    private func configuration(with record: [InterestedReadingBooks]) {
        if let imageURL = record[0].thumbnail {
            recordBookThumbnailImageView.setImageKingfisher(with: imageURL)
        } else {
            recordBookThumbnailImageView.image = UIImage(named: "unknownBook")
        }
        recordBookTitleLabel.text = record[0].name
    }
}
