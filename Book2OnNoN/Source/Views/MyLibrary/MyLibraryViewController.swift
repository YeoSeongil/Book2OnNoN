//
//  MyLibraryViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MyLibraryViewController: BaseViewController {
    private let viewModel: MyLibraryViewModelType
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    //MARK: UI Components
    private let finishedReadingBookCollectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FinishedReadingBookCollectionViewCell.self, forCellWithReuseIdentifier:FinishedReadingBookCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    init(viewModel: MyLibraryViewModelType = MyLibraryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setViewController() {
        super.setViewController()
        [finishedReadingBookCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        finishedReadingBookCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setNavigation() {
        super.setNavigation()
    }
    
    override func bind() {
        finishedReadingBookCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        finishedReadingBookCollectionView.rx.modelSelected(FinishedReadingBooks.self)
            .bind(onNext: { [weak self] record in
                let recordViewModel = FinishedReadingBookRecordViewModel(finishedReadingBookRecordData: record)
                let recordViewController = FinishedReadingBookRecordViewController(viewModel: recordViewModel)
                self?.navigationController?.pushViewController(recordViewController, animated: true)
            }).disposed(by: disposeBag)
        
        // Output
        viewModel.finishedReadingBookRecordItem
            .drive(finishedReadingBookCollectionView.rx.items(cellIdentifier: FinishedReadingBookCollectionViewCell.id, cellType: FinishedReadingBookCollectionViewCell.self)) { row, item, cell in
                cell.configuration(book: item)
            }.disposed(by: disposeBag)
    }
}

extension MyLibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top + 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
