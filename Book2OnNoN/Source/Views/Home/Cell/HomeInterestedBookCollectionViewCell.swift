//
//  HomeInterestedBookCollectionViewCell.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/13/24.
//

import UIKit
import SnapKit

class HomeInterestedBookCollectionViewCell: UICollectionViewCell {
    static let id: String = "HomeInterestedBookCollectionViewCell"
    
    private let homeInterestedBookThumbnailImageView: UIImageView = {
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
        [homeInterestedBookThumbnailImageView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraint() {
        homeInterestedBookThumbnailImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
    }

    // MARK: Configuration
    func configuration(book: InterestedReadingBooks) {
        if let imageURL = book.thumbnail {
            homeInterestedBookThumbnailImageView.setImageKingfisher(with: imageURL)
        } else {
            homeInterestedBookThumbnailImageView.image = UIImage(named: "unknownBook")
        }
    }
}
