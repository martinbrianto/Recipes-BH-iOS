//
//  FirstLetterSelectOptionTableViewCell.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import UIKit

final class FirstLetterSelectOptionTableViewCell: UITableViewCell {
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        return imageView
    }()
    
    // MARK: - Variables
    static let reuseID = "FirstLetterSelectOptionTableViewCell"
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func configure(isSelected: Bool, optionName: String) {
        titleLabel.text = optionName
        optionImageView.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
    }
    
    // MARK: - Setup
    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(optionImageView)
        
        optionImageView.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.leading.top.bottom.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(optionImageView.snp.trailing).offset(8)
            make.trailing.bottom.top.equalToSuperview().inset(8)
        }
    }
}
