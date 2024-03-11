//
//  BaseViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/11/24.
//

import UIKit.UIViewController
import RxSwift

class BaseViewController: UIViewController {
    
    final let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setViewController()
        setAddViews()
        setConstraints()
        setNavigation()
        bind()
    }
    
    // MARK: setUp ViewController Method
    
    /// ViewController의 기초를 설정합니다. (배경색상 등)
    /// ```
    /// func setViewController() {
    ///    self.view.backgroundColor = .white
    ///    // another codes ...
    /// }
    /// ```
    func setViewController() { }
    
    /// UI 프로퍼티를 View 요소에 Add합니다.
    /// ```
    /// func setAddViews() {
    ///   self.view.addSubView(label)
    ///    // another codes ...
    /// }
    /// ```
    func setAddViews() { }
    
    /// Navigation을 설정합니다.
    /// ```
    /// func setNavigation() {
    ///    self.navigationItem.title = "나의 서재"
    ///    // another codes ...
    /// }
    /// ```
    func setNavigation() { }
    
    /// UI 프로퍼티의 제약조건을 설정합니다.
    /// (본 프로젝트에서는 Snapkit을 사용합니다.)
    /// ```
    /// func setConstraints() {
    ///    view.snp.makeConstraints {
    ///       $0.width.equalTo(10)
    ///    // another codes ...
    /// }
    /// ```
    func setConstraints() { }

    /// UI 핸들링을 위해 Bind합니다.
    /// (본 프로젝트에서는 RxSwift를 사용합니다.)
    /// ```
    /// // Input
    /// func bind() {
    ///   textField.rx.text.orEmpty
    ///      .bind(to: viewModel.whichText)
    ///      .disposed(by: disposeBag)
    ///    // another codes ...
    /// }
    /// ```
    func bind() { }
}
