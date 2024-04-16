//
//  ReadingBookRecrodViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData

class ReadingBookRecordViewController: BaseViewController {
    
    private let viewModel: ReadingBookRecordViewModelType
    
    private lazy var readingBookRecordSummaryView = ReadingBookRecordSummaryView(viewModel: viewModel)
    // MARK: UI Components
    
    // MARK: init
    init(viewModel: ReadingBookRecordViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUp ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setViewController() {
        super.setViewController()
        [readingBookRecordSummaryView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        readingBookRecordSummaryView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(200)
        }
    }
    
    override func setNavigation() {
        super.setNavigation()
    }
    
    override func bind() {
        super.bind()
    }
}
