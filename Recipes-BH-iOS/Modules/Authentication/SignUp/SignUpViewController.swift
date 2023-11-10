//
//  SignUpViewController.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import UIKit
import SnapKit
import RxSwift

class SignUpViewController: UIViewController {
    
    
    // MARK: - UI Components
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.configuration = .filled()
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "Error msg"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    // MARK: - Variables
    
    private let viewModel: SignUpViewModel
    
    private let _rxDidSuccessSignUp = PublishSubject<Void>()
    var rxDidSuccessSignUp: Observable<Void> { _rxDidSuccessSignUp }
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(viewModel: SignUpViewModel = SignUpViewModelImpl()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    
    private func processSignUp() {
        let email = emailTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let repeatPassword = confirmPasswordTextField.text ?? ""
        viewModel.processUserSignUp(email: email, name: name, password: password, repeatPassword: repeatPassword)
    }
    
    // MARK: - Setup
    
    private func setupView() {
        navigationItem.title = "Sign Up"
        view.backgroundColor = .systemBackground

        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(signupButton)
        view.addSubview(errorLabel)
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(40)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(40)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(40)
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(30)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(50)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(signupButton.snp.bottom).offset(30)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
        }
    }
    
    private func setupBinding() {
        signupButton.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.view.endEditing(true)
                self?.processSignUp()
            })
            .disposed(by: disposeBag)
        
        viewModel.rxSignUpResult
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] signUpResult in
                switch signUpResult {
                case let .failure(error):
                    self?.errorLabel.isHidden = false
                    if let error = error as? FormError {
                        self?.errorLabel.text = error.description
                    } else {
                        self?.errorLabel.text = error.localizedDescription
                    }
                case .success:
                    self?.errorLabel.isHidden = true
                    self?.navigationController?.popViewController(animated: true, completion: { 
                        self?._rxDidSuccessSignUp.onNext(())
                    })
                    print("success")
                }
            })
            .disposed(by: disposeBag)
    }
}
