//
//  SearchDetailDescriptionView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/15/24.
//

import UIKit
import SnapKit

class SearchDetailDescriptionView: UIView {

    // MARK: UIComponents
    private let detailBookDescriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "줄거리"
        label.font = .Pretendard.semibold
        label.textColor = .white
        return label
    }()
    
    private let detailBookDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .Pretendard.regular
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
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
        [detailBookDescriptionTitleLabel, detailBookDescriptionTextView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        detailBookDescriptionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        detailBookDescriptionTextView.snp.makeConstraints {
            $0.top.equalTo(detailBookDescriptionTitleLabel.snp.bottom)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    // MARK: Method
    func configuration(with item: Item) {
        detailBookDescriptionTextView.text = item.description
    }
}
