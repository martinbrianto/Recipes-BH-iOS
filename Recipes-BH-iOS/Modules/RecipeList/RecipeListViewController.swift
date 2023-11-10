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
    
    // MARK: - Variables
    
    private let viewModel: RecipeListViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(viewModel: RecipeListViewModel = RecipeListViewModelImpl()) {
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
        viewModel.getRecipeList()
    }
    
    // MARK: - Methods
    
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
    
    // MARK: - Setup
    
    private func setupView() {
        navigationItem.title = "Recipe List"
        navigationItem.rightBarButtonItem = changeRecipeLetterBarButton
        
        view.backgroundColor = .white
        
        view.addSubview(activityView)
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
    }
    
    private func setupBinding() {
        viewModel.rxViewState
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] state in
                switch state {
                case .loading:
                    print("loading")
                case .loaded:
                    print("loaded")
                    self?.tableView.reloadData()
                case let .error(errorDesc):
                    print(errorDesc)
                }
            })
            .disposed(by: disposeBag)
        
        changeRecipeLetterBarButton.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.presentSelectFirstLetterVc()
            })
            .disposed(by: disposeBag)
        
        viewModel.rxFirstLetterParam
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] firstLetter in
                self?.firstLetterTitleLabel.text = "Showing recipes that starts from letter → \(firstLetter)"
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UITableViewDelegate
extension RecipeListViewController: UITableViewDelegate {
    
}
