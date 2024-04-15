//
//  RegisterViewController.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData

class RegisterViewController: BaseViewController {
    
    private let viewModel: RegisterViewModelType
    
    // MARK: UI Components
    private let registerUserNameLabel: UILabel = {
        let label = UILabel()
        label.text = "북이온앤온에서 사용할 이름이나\n닉네임을 입력해주세요"
        label.font = .Pretendard.semibold
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var registerUserNameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width - 240, height: 30))
        textField.layer.addBorder(edge: .bottom, color: .white, thickness: 2)
        textField.textColor = .white
        textField.font = .Pretendard.semibold
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.semibold
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.backgroundColor = .clear
        return button
    }()
    
    // MARK: init
    init(viewModel: RegisterViewModelType = RegisterViewModel()) {
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
        [registerUserNameLabel, registerUserNameTextField, registerButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        registerUserNameLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }
        
        registerUserNameTextField.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(120)
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        
        registerButton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(30)
            $0.leading.equalTo(registerUserNameTextField.snp.trailing).offset(15)
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func setNavigation() {
        super.setNavigation()
    }
    
    override func bind() {
        // Input
        registerUserNameTextField.rx.text.orEmpty
            .bind(to: viewModel.didRegisterUserName)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind(to: viewModel.didRegisterButtonTapped)
            .disposed(by: disposeBag)
        
        
        // Output
        viewModel.resultRegisterError
            .drive(onNext: { result in
                switch result {
                case .emptyRegisterTextField:
                    self.registerUserNameTextField.shakeAnimation()
                }})
            .disposed(by: disposeBag)
        
        viewModel.resultRegisterSaveProcedureType
            .drive(onNext: { err in
                switch err {
                case .successSave:
                    self.showOnlyOkAlert(title: "😄", message: "가입에 성공했어요.", buttonTitle: "확인했어요", handler: { _ in
                        //self.navigationController?.popToRootViewController(animated: true)
                    })
                case .failureSave:
                    self.showOnlyOkAlert(title: "😢", message: "가입에 실패했어요.", buttonTitle: "확인했어요", handler: .none)
                }
            })
            .disposed(by: disposeBag)
    }
}
