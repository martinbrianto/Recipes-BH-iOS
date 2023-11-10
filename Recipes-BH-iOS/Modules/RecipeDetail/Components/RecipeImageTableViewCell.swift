//
//  RecipeImageTableViewCell.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import UIKit
import Nuke

final class RecipeImageTableViewCell: UITableViewCell {

    // MARK: - UI Components
    
    private let recipeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    // MARK: - Variables
    
    static var reuseID = "RecipeImageTableViewCell"
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(imageUrl: String) {
        if let imageUrl = URL(string: imageUrl) {
            let options = ImageLoadingOptions(placeholder: UIImage(named: "image-placeholder"), transition: .fadeIn(duration: 0.5))
            Nuke.loadImage(with: imageUrl, options: options, into: recipeImageView)
        }
    }
    
    // MARK: - Setup
    
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(recipeImageView)
        
        recipeImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(400)
        }
    }

}
