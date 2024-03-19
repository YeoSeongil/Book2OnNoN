//
//  SearchDetailRecordButtonView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol SearchDetailRecordButtonViewDelegate: AnyObject {
    func didTappedRecordFinishedReadingButton()
    func didTappedRecordReadingButton()
    func didrecordInterestedButton()
}

class SearchDetailRecordButtonView: UIView {

    weak var delegate: SearchDetailRecordButtonViewDelegate?
    private let disposeBag = DisposeBag()
    
    // MARK: UIComponents
    private let recordButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let recordFinishedReadingButton: UIButton = {
        let button = UIButton()
        button.setTitle("다 읽은 책", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.semibold
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.backgroundColor = .PrestigeBlue
        return button
    }()    
    
    private let recordReadingButton: UIButton = {
        let button = UIButton()
        button.setTitle("읽고 있는 책", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.semibold
        button.tintColor = .white
        button.layer.cornerRadius = 5
        return button
    }()    
    
    private let recordInterestedButton: UIButton = {
        let button = UIButton()
        button.setTitle("관심 있는 책", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.semibold
        button.tintColor = .white
        button.layer.cornerRadius = 5
        return button
    }()

    // MARK: init
    override init(frame: CGRect) {
      super.init(frame: frame)
        setView()
        setConfiguration()
        bind()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set View
    private func setView() {
        [recordButtonStackView].forEach {
            addSubview($0)
        }
        
        [recordFinishedReadingButton, recordReadingButton, recordInterestedButton].forEach {
            recordButtonStackView.addArrangedSubview($0)
        }
    }
    
    private func setConfiguration() {
        recordButtonStackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        recordFinishedReadingButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedRecordFinishedReadingButton()
            }).disposed(by: disposeBag)
        
        recordReadingButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedRecordReadingButton()
            }).disposed(by: disposeBag)
        
        recordInterestedButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didrecordInterestedButton()
            }).disposed(by: disposeBag)
    }
}
