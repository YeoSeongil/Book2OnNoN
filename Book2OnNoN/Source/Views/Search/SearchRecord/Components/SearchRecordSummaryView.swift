//
//  SearchDetailSummaryView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/15/24.
//

import UIKit
import SnapKit

class SearchRecordSummaryView: UIView {

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
    override init(frame: CGRect) {
      super.init(frame: frame)
        setView()
        setConstraints()
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
    
    // MARK: Method
    func configuration(with item: Item) {
        recordBookThumbnailImageView.setImageKingfisher(with: item.cover)
        recordBookTitleLabel.text = item.title
        recordBookAuthorLabel.text = item.author
    }
}
