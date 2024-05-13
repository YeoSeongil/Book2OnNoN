//
//  InterestedBookRecordViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData

class InterestedBookRecordViewController: BaseViewController {
    private let viewModel: InterestedBookRecordViewModelType
    
    private lazy var interestedBookRecordSummaryView = InterestedBookRecordSummaryView(viewModel: viewModel)
    
    // MARK: UI Components
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: init
    init(viewModel: InterestedBookRecordViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUp ViewController
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setViewController() {
        super.setViewController()
        [interestedBookRecordSummaryView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        interestedBookRecordSummaryView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(200)
        }
    }
    
    override func setNavigation() {
        super.setNavigation()
        let rightDeleteButton = UIBarButtonItem(customView: deleteButton)
        self.navigationItem.rightBarButtonItem = rightDeleteButton
    }
    
    override func bind() {
        super.bind()
        // Input
        deleteButton.rx.tap
            .bind(to: viewModel.didDeleteButtonTapped)
            .disposed(by: disposeBag)
    }
}
