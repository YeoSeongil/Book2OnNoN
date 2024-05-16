//
//  FinishedReadingBookCollectionViewCell.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/16/24.
//

import UIKit
import SnapKit

class FinishedReadingBookCollectionViewCell: UICollectionViewCell {
    static let id: String = "FinishedReadingBookCollectionViewCell"
    
    private let finishedReadingBookThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
        setAddViews()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: SetUp Cell
    private func setCell() {
        backgroundColor = .black
    }
    
    private func setAddViews() {
        [finishedReadingBookThumbnailImageView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraint() {
        finishedReadingBookThumbnailImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
    }

    // MARK: Configuration
    func configuration(book: FinishedReadingBooks) {
        if let imageURL = book.thumbnail {
            finishedReadingBookThumbnailImageView.setImageKingfisher(with: imageURL)
        } else {
            finishedReadingBookThumbnailImageView.image = UIImage(named: "unknownBook")
        }
    }
}
