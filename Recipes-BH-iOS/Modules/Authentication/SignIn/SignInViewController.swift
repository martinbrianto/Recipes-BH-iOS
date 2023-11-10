//
//  SignInViewController.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import UIKit
import SnapKit
import RxSwift

class SignInViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
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
    
    private let viewModel: SignInViewModel
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(viewModel: SignInViewModel = SignInViewModelImpl()) {
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
    
    private func processSignIn() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        viewModel.processUserSignIn(email: email, password: password)
    }
    
    // MARK: - Setup
    
    private func setupView() {
        navigationItem.title = "Sign In"
        view.backgroundColor = .systemBackground
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(errorLabel)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
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
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(50)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
        }
    }
    
    private func setupBinding() {
        signInButton.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.view.endEditing(true)
                self?.processSignIn()
            })
            .disposed(by: disposeBag)
        
        viewModel.rxSignInResult
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] signInResult in
                switch signInResult {
                case let .failure(error):
                    self?.errorLabel.isHidden = false
                    
                    if let error = error as? SignInError {
                        self?.errorLabel.text = error.description
                    }
                    else if let error = error as? FormError {
                        self?.errorLabel.text = error.description
                    }
                    
                case .success:
                    print("success")
                    self?.errorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
    
}
