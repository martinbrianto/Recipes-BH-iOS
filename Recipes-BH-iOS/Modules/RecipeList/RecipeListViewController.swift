//
//  RecipeListViewController.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import UIKit
import RxSwift

final class RecipeListViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let emptyView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "empty-search")
        view.isHidden = true
        return view
    }()
    
    private let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.isHidden = true
        return view
    }()
    
    private let firstLetterTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Showing recipes that starts from letter → A"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.reuseID)
        return tableView
    }()
    
    private let changeRecipeLetterBarButton = UIBarButtonItem(image: UIImage(systemName: "textformat"))
    private let logOutBarButton = UIBarButtonItem(title: "Log out")
    
    // MARK: - Variables
    
    private let viewModel: RecipeListViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(viewModel: RecipeListViewModel = RecipeListViewModelImpl()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupBinding()
        viewModel.getRecipeList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func presentErrorAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func setEmptyView(isShowing: Bool) {
        emptyView.isHidden = !isShowing
        tableView.isHidden = isShowing
    }
    
    private func setLoadingView(isShowing: Bool) {
        if isShowing {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
        tableView.isHidden = isShowing
        activityView.isHidden = !isShowing
    }
    
    func showLogoutConfirmationAlert() {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.viewModel.logOutUser()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Setup
    
    private func setupView() {
        navigationItem.title = "Welcome, \(viewModel.getUserName())"
        navigationItem.rightBarButtonItem = changeRecipeLetterBarButton
        navigationItem.leftBarButtonItem = logOutBarButton
        
        view.backgroundColor = .white
        
        view.addSubview(activityView)
        view.addSubview(emptyView)
        view.addSubview(firstLetterTitleLabel)
        view.addSubview(tableView)
        
        firstLetterTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        activityView.snp.makeConstraints { make in
            make.top.equalTo(firstLetterTitleLabel.snp.bottom).offset(16)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(firstLetterTitleLabel.snp.bottom).offset(16)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        emptyView.snp.makeConstraints { make in
            make.size.equalTo(300)
            make.centerY.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupBinding() {
        viewModel.rxViewState
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] state in
                guard let self else { return }
                switch state {
                case .loading:
                    self.setLoadingView(isShowing: true)
                case .loaded:
                    self.setLoadingView(isShowing: false)
                    self.setEmptyView(isShowing: self.viewModel.recipes.isEmpty)
                    self.tableView.reloadData()
                case let .error(errorDesc):
                    self.setLoadingView(isShowing: false)
                    self.presentErrorAlert(title: "Error Occured", description: errorDesc)
                }
            })
            .disposed(by: disposeBag)
        
        changeRecipeLetterBarButton.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.presentSelectFirstLetterVc()
            })
            .disposed(by: disposeBag)
        
        logOutBarButton.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.showLogoutConfirmationAlert()
            })
            .disposed(by: disposeBag)
        
        viewModel.rxFirstLetterParam
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] firstLetter in
                self?.firstLetterTitleLabel.text = "Showing recipes that starts from letter → \(firstLetter)"
            })
            .disposed(by: disposeBag)
        
        viewModel.rxUserDidLogout
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.logOutUser()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource
extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellData = viewModel.recipes[safe: indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.reuseID, for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }
        
        cell.configure(recipeName: cellData.strMeal, thumbnailUrl: cellData.strMealThumb)
        
        cell.rxDidTapImage
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.presentImageViewer(for: cellData.strMealThumb)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UITableViewDelegate
extension RecipeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellData = viewModel.recipes[safe: indexPath.row] else { return }
        goToRecipesDetail(for: cellData.idMeal)
    }
}

// MARK: - Navigation
extension RecipeListViewController {
    private func goToRecipesDetail(for id: String) {
        let vc = RecipeDetailViewController(viewModel: RecipeDetailViewModelImpl(recipeId: id))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentSelectFirstLetterVc() {
        let vc = FirstLetterSelectViewController(selectedFirstLetterOption: viewModel.recipeFirstLetterParam)
        
        vc.rxSelectedOption
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] selectedOption in
                self?.viewModel.changeFirstLetterParam(to: selectedOption)
            })
            .disposed(by: vc.disposeBag)
        
        present(vc, animated: true)
    }
    
    private func presentImageViewer(for imageUrl: String) {
        let vc = ImageViewerViewController(imageUrl: imageUrl)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
}
