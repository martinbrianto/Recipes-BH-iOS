//
//  RecipeTableViewCell.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import UIKit
import RxSwift
import Nuke

final class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private let recipeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Variables
    
    static let reuseID = "RecipeTableViewCell"
    var disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    // MARK: - Methods
    
    func configure(recipeName: String, thumbnailUrl: String) {
        recipeLabel.text = recipeName
        
        if let thumbnailUrl = URL(string: thumbnailUrl + "/preview") {
            let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.5))
            Nuke.loadImage(with: thumbnailUrl, options: options, into: thumbnailImageView)
        }
    }
    
    // MARK: - Setup
    
    private func setupView() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(recipeLabel)
        
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(80)
        }
        
        recipeLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            make.trailing.top.bottom.equalToSuperview().inset(8)
        }
    }
}
