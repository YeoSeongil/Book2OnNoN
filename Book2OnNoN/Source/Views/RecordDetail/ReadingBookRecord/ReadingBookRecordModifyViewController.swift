//
//  ReadingBookRecordModifyViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData

class ReadingBookRecordModifyViewController: BaseViewController {
    private let viewModel: ReadingBookRecordViewModelType
    
    private lazy var readingBookRecordContentView = ReadingBookRecordContentView(viewModel: viewModel)
    
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setViewController() {
        super.setViewController()
        [readingBookRecordContentView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        readingBookRecordContentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(200)
        }
    }
    
    override func bind() {
        super.bind()
        
        // Input
        
        // Output
    }
}
