//
//  SearchResultTableViewCell.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/13/24.
//

import UIKit
import SnapKit

class SearchResultTableViewCell: UITableViewCell {

    static let id: String = "SearchResultTableViewCell"
    
    // MARK: UI Components
    private let bookThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .Pretendard.cellBookTitle
        label.numberOfLines = 2
        return label
    }()
    
    private let bookAuthorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .Pretendard.medium
        label.numberOfLines = 2
        return label
    }()
    
    private let bookPublisherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .Pretendard.medium
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
        setAddViews()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: SetUp Cell
    private func setCell() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setAddViews() {
        [bookThumbnailImageView, bookTitleLabel, bookAuthorLabel, bookPublisherLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraint() {
        bookThumbnailImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().offset(5)
            $0.width.equalTo(70)
        }
        
        bookTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(bookThumbnailImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(5)
        }
        
        bookAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(bookTitleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(bookThumbnailImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(5)
        }
        
        bookPublisherLabel.snp.makeConstraints {
            $0.top.equalTo(bookAuthorLabel.snp.bottom).offset(5)
            //$0.bottom.equalToSuperview().inset(5)
            $0.leading.equalTo(bookThumbnailImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(5)
        }
    }

    // MARK: Configuration
    func configuration(book: Item) {
        bookThumbnailImageView.setImageKingfisher(with: book.cover)
        bookTitleLabel.text = book.title
        bookAuthorLabel.text = book.author
        bookPublisherLabel.text = book.publisher
    }
}
