//
//  HomeReadingBookCollectionViewCell.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/9/24.
//

import UIKit
import SnapKit

class HomeReadingBookCollectionViewCell: UICollectionViewCell {
    
    static let id: String = "HomeReadingBookCollectionViewCell"
    
    private let homeReadingBookThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let homeReadingBookTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .Pretendard.cellBookTitle
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
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
        [homeReadingBookThumbnailImageView, homeReadingBookTitleLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraint() {
        homeReadingBookThumbnailImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(120)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        homeReadingBookTitleLabel.snp.makeConstraints {
            $0.top.equalTo(homeReadingBookThumbnailImageView.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: Configuration
    func configuration(book: ReadingBooks) {
        if let imageURL = book.thumbnail {
            homeReadingBookThumbnailImageView.setImageKingfisher(with: imageURL)
        } else {
            homeReadingBookThumbnailImageView.image = UIImage(named: "unknownBook")
        }
        homeReadingBookTitleLabel.text = book.name
    }
}

