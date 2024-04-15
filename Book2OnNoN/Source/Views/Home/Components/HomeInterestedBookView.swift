//
//  HomeInterestedBookView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/13/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class HomeInterestedBookView: UIView {
    
    private let disposeBag = DisposeBag()
    private let viewModel: HomeViewModelType
    
    // MARK: UI Components
    private let homeInterestedBookViewLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 있는 책"
        label.textColor = .white
        label.font = .Pretendard.semibold
        return label
    }()
    
    private let interestedBookCollectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeInterestedBookCollectionViewCell.self, forCellWithReuseIdentifier:HomeInterestedBookCollectionViewCell.id)
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
        [homeInterestedBookViewLabel, interestedBookCollectionView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        homeInterestedBookViewLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        interestedBookCollectionView.snp.makeConstraints {
            $0.top.equalTo(homeInterestedBookViewLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        interestedBookCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // Output
        viewModel.resultInterestedBookRecordItem
            .drive(interestedBookCollectionView.rx.items(cellIdentifier: HomeInterestedBookCollectionViewCell.id, cellType: HomeInterestedBookCollectionViewCell.self)) { row, item, cell in
                cell.configuration(book: item)
            }.disposed(by: disposeBag)
    }
}

extension HomeInterestedBookView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewWidth = collectionView.bounds.width - (padding * 4) // 왼쪽, 오른쪽 패딩을 포함하여 전체 너비 계산
        let cellWidth = collectionViewWidth / 3 // 전체 너비의 1/3 크기로 셀의 너비 설정
        let cellHeight = collectionView.bounds.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
