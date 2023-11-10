//
//  RecipeDetailViewController.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import UIKit
import RxSwift
import SafariServices

final class RecipeDetailViewController: UIViewController {
    
    enum CellType: Int {
        case imageCell
    }
    
    // MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RecipeImageTableViewCell.self, forCellReuseIdentifier: RecipeImageTableViewCell.reuseID)
        tableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: IngredientTableViewCell.reuseID)
        return tableView
    }()
    
    private let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.isHidden = true
        return view
    }()
    
    private let youtubeButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("See recipe on Youtube", for: .normal)
        return button
    }()
    
    // MARK: - Variables
    
    private let viewModel: RecipeDetailViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(viewModel: RecipeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupBinding()
        viewModel.getRecipeDetail()
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
    
    private func setLoadingView(isShowing: Bool) {
        if isShowing {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
        tableView.isHidden = isShowing
        activityView.isHidden = !isShowing
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(activityView)
        
        let buttonContainer = UIView()
        buttonContainer.backgroundColor = .lightGray
        buttonContainer.addSubview(youtubeButton)
        
        view.addSubview(buttonContainer)
        
        buttonContainer.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        youtubeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.top.right.equalToSuperview().inset(8)
            make.bottom.equalTo(buttonContainer.safeAreaLayoutGuide).inset(8)
        }
        
        activityView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(32)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(buttonContainer.snp.top)
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
                    self.navigationItem.title = self.viewModel.recipesDetail.strMeal
                    self.tableView.reloadData()
                case let .error(errorDesc):
                    self.setLoadingView(isShowing: false)
                    self.presentErrorAlert(title: "Error Occured", description: errorDesc)
                }
            })
            .disposed(by: disposeBag)
        
        youtubeButton.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.openWebViewWithSafari(urlString: self?.viewModel.recipesDetail.strYoutube ?? "" )
            })
            .disposed(by: disposeBag)
        
        
        
    }
    
    // MARK: - Private Methods
    
    func openWebViewWithSafari(urlString: String) {
        // Check if the URL is valid
        if let url = URL(string: urlString) {
            // Initialize a Safari View Controller with the provided URL
            let safariViewController = SFSafariViewController(url: url)
            
            // Present the Safari View Controller modally
            present(safariViewController, animated: true, completion: nil)
        } else {
            // Handle invalid URL here
            print("Invalid URL: \(urlString)")
        }
    }
    
}

// MARK: - UITableViewDataSource
extension RecipeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipesDetail.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case CellType.imageCell.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeImageTableViewCell.reuseID) as? RecipeImageTableViewCell else { return UITableViewCell() }
            cell.configure(imageUrl: viewModel.recipesDetail.strMealThumb)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell.reuseID) as? IngredientTableViewCell else { return UITableViewCell() }
            cell.configure(with: viewModel.recipesDetail.ingredients[safe: indexPath.row] ?? "", measure: viewModel.recipesDetail.measures[safe: indexPath.row] ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case CellType.imageCell.rawValue: return 400
        default: return UITableView.automaticDimension
        }
    }
}
