//
//  SearchDetailViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchDetailViewController: BaseViewController {
    
    private let viewModel: SearchDetailViewModelType
    // MARK: UI Components
    
    private lazy var testLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    // MARK: init
    init(viewModel: SearchDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUp ViewController
    override func setViewController() {
        super.setViewController()
        view.backgroundColor = .blue
    }
    
    override func setAddViews() {
        super.setAddViews()
        [testLabel].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        testLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(100)
        }
    }
    
    override func bind() {
        super.bind()
        viewModel.resultDetailItem
            .drive(onNext: { [weak self] item in
                guard let item = item else { return }
                self?.testLabel.text = item.title
            })
            .disposed(by: disposeBag)
    }
}
