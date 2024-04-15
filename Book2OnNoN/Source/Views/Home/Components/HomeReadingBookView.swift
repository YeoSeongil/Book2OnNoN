//
//  HomeReadingBookView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class HomeReadingBookView: UIView {
    
    private let disposeBag = DisposeBag()
    private let viewModel: HomeViewModelType
    
    // MARK: UI Components
    private let homeReadingBookViewLabel: UILabel = {
        let label = UILabel()
        label.text = "읽고 있는 책"
        label.textColor = .white
        label.font = .Pretendard.semibold
        return label
    }()
    
    private let readingBookCollectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeReadingBookCollectionViewCell.self, forCellWithReuseIdentifier:HomeReadingBookCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: init
    init(viewModel: HomeViewModelType) {
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
        [homeReadingBookViewLabel, readingBookCollectionView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        homeReadingBookViewLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        readingBookCollectionView.snp.makeConstraints {
            $0.top.equalTo(homeReadingBookViewLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        readingBookCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // Output
        viewModel.resultReadingBookRecordItem
            .drive(readingBookCollectionView.rx.items(cellIdentifier: HomeReadingBookCollectionViewCell.id, cellType: HomeReadingBookCollectionViewCell.self)) { row, item, cell in
                cell.configuration(book: item)
            }.disposed(by: disposeBag)
    }
}

extension HomeReadingBookView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let hegiht: CGFloat = collectionView.bounds.height
        return CGSize(width: width, height: hegiht)
    }
}
