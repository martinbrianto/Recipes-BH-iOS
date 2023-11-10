//
//  FirstLetterSelectViewController.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import UIKit
import RxSwift

final class FirstLetterSelectViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Change Recipe First Letter"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FirstLetterSelectOptionTableViewCell.self, forCellReuseIdentifier: FirstLetterSelectOptionTableViewCell.reuseID)
        return tableView
    }()
    
    // MARK: - Variables
    
    private var selectedFirstLetterOption: Character
    
    private let _rxSelectedOption = PublishSubject<Character>()
    var rxSelectedOption: Observable<Character> { _rxSelectedOption }
    var disposeBag = DisposeBag()
    
    private let alphabets: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    // MARK: - Inits
    
    init(selectedFirstLetterOption: Character) {
        self.selectedFirstLetterOption = selectedFirstLetterOption
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
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.right.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func setupBinding() {
        closeButton.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource
extension FirstLetterSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alphabets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellData = alphabets[safe: indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: FirstLetterSelectOptionTableViewCell.reuseID, for: indexPath) as? FirstLetterSelectOptionTableViewCell else { return UITableViewCell() }
        
        cell.configure(isSelected: selectedFirstLetterOption == cellData, optionName: "\(cellData)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 41
    }
}

// MARK: - UITableViewDelegate
extension FirstLetterSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let previousSelectedIndex = alphabets.firstIndex(of: selectedFirstLetterOption),
              let selectedOption = alphabets[safe: indexPath.row]
        else { return }
        
        selectedFirstLetterOption = selectedOption
        tableView.reloadRows(at: [IndexPath(row: previousSelectedIndex, section: 0), indexPath], with: .none)
        
        dismiss(animated: true) { [weak self] in
            self?._rxSelectedOption.onNext(selectedOption)
        }
    }
}

