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

enum RecordButtonType {
    case finishedReading
    case reading
    case interested
}

protocol SearchRecordButtonViewDelegate: AnyObject {
    func didTapRecordButton(type: RecordButtonType)
}

class SearchDetailRecordButtonView: UIView {

    weak var delegate: SearchRecordButtonViewDelegate?
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
        setConstraints()
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
    
    private func setConstraints() {
        recordButtonStackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        let buttons = [recordFinishedReadingButton, recordReadingButton, recordInterestedButton]
        
        buttons.forEach { button in
            button.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    buttons.forEach { $0.backgroundColor = .clear} // 모든 버튼의 색상 초기화
                    button.backgroundColor = .PrestigeBlue // 선택된 버튼만 색상 변경

                    if button == self?.recordFinishedReadingButton {
                        self?.delegate?.didTapRecordButton(type: .finishedReading)
                    } else if button == self?.recordReadingButton {
                        self?.delegate?.didTapRecordButton(type: .reading)
                    } else if button == self?.recordInterestedButton {
                        self?.delegate?.didTapRecordButton(type: .interested)
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}
