//
//  RegisterViewModel.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

enum RegisterError {
    case emptyRegisterTextField
}

enum RegisterSaveProcedureType  {
    case successSave
    case failureSave
}

protocol RegisterViewModelType {
    // Input
    var didRegisterButtonTapped: AnyObserver<Void> { get }
    var didRegisterUserName: AnyObserver<String> { get }

    // Output
    var resultRegisterError: Driver<RegisterError> { get }
    var resultRegisterSaveProcedureType: Driver<RegisterSaveProcedureType> { get }
}

class RegisterViewModel {
    
    private let disposeBag = DisposeBag()
    // Input
    private let inputDidRegisterButtonTapped = PublishSubject<Void>()
    private let inputRegisterUserName = PublishSubject<String>()
    
    // Output
    private let outputRegisterError = PublishRelay<RegisterError>()
    private let outputRegisterSaveProcedureType = PublishRelay<RegisterSaveProcedureType>()
    
    init() {
        trySaveUserData()
    }
    
    private func trySaveUserData() {
        inputDidRegisterButtonTapped
            .withLatestFrom(inputRegisterUserName)
            .subscribe(onNext: { name in
                if name.isEmpty {
                    self.outputRegisterError.accept(.emptyRegisterTextField)
                } else {
                    if let data = CoreDataManager.shared.insertData(Book2OnNonUser.self) {
                        data.isRegister = true
                        data.name = name
                        
                        CoreDataManager.shared.saveData { result in
                            switch result {
                            case .success:
                                self.outputRegisterSaveProcedureType.accept(.successSave)
                            case .failure(let errorr):
                                self.outputRegisterSaveProcedureType.accept(.failureSave)
                            }
                        }
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func handleRegisterResult(_ result: Book) {
    }
    
    
}

extension RegisterViewModel: RegisterViewModelType {
    // Input
    var didRegisterButtonTapped: AnyObserver<Void> {
        inputDidRegisterButtonTapped.asObserver()
    }
    
    var didRegisterUserName: AnyObserver<String> {
        inputRegisterUserName.asObserver()
    }
    
    // Output
    var resultRegisterError: Driver<RegisterError> {
        outputRegisterError.asDriver(onErrorDriveWith: .empty())
    }
    
    var resultRegisterSaveProcedureType: Driver<RegisterSaveProcedureType> {
        outputRegisterSaveProcedureType.asDriver(onErrorDriveWith: .empty())
    }

    
}

