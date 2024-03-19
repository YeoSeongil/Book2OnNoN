//
//  SearchDetailSummaryView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/15/24.
//

import UIKit
import SnapKit

class SearchDetailSummaryView: UIView {

    // MARK: UIComponents
    private let detailBookThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let detailBookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard.semibold
        label.numberOfLines = 5
        label.textColor = .white
        return label
    }()
        
    private let detailBookAuthorLabel: UILabel = {
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
        setConfiguration()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set View
    private func setView() {
        [detailBookThumbnailImageView, detailBookTitleLabel, detailBookAuthorLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConfiguration() {
        detailBookThumbnailImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalToSuperview()
            $0.centerY.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        detailBookTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(detailBookAuthorLabel.snp.top).offset(-10)
            $0.leading.equalTo(detailBookThumbnailImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(safeAreaInsets)
        }
        
        detailBookAuthorLabel.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaInsets)
            $0.leading.equalTo(detailBookThumbnailImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(safeAreaInsets)
        }

    }
    
    // MARK: Method
    func configuration(with item: Item) {
        detailBookThumbnailImageView.setImageKingfisher(with: item.cover)
        detailBookTitleLabel.text = item.title
        detailBookAuthorLabel.text = item.author
    }
}
