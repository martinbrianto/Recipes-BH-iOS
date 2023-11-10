//
//  IngredientTableViewCell.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import UIKit

final class IngredientTableViewCell: UITableViewCell {

    // MARK: - UI Components
    
    private let ingredientLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let measureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Variables
    
    static var reuseID = "IngredientTableViewCell"
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with ingredient: String, measure: String) {
        ingredientLabel.text = ingredient.capitalized
        measureLabel.text = measure
    }
    
    // MARK: - Setup
    
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(ingredientLabel)
        contentView.addSubview(measureLabel)
        
        ingredientLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
        }
        
        measureLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-16)
            make.centerY.equalTo(contentView)
        }
    }
}
