//
//  EntryViewController.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class EntryViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "app_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "BitHealth Recipes"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.configuration = .filled()
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.configuration = .filled()
        return button
    }()
    
    // MARK: - Variables
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
    
    private func goToSignInScreen() {
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToSignUpScreen() {
        let vc = SignUpViewController()
        
        vc.rxDidSuccessSignUp
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.goToSignInScreen()
            })
            .disposed(by: vc.disposeBag)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(appIconImageView)
        view.addSubview(appNameLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        appIconImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.height.width.equalTo(100)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(appIconImageView.snp.bottom).offset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(50)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(50)
        }
    }
    
    private func setupBinding() {
        signUpButton.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.goToSignUpScreen()
            })
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.goToSignInScreen()
            })
            .disposed(by: disposeBag)
    }
}
