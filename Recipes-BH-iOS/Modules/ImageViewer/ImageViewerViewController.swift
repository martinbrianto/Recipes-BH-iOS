//
//  ImageViewerViewController.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import UIKit
import Nuke
import RxSwift

class ImageViewerViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let uiImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let backgroundView = UIControl()
    
    // MARK: - Variables
    
    let disposeBag = DisposeBag()
    private let imageUrl: String
    
    // MARK: - Inits
    init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundView.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.03137254902, blue: 0.1137254902, alpha: 0.6)
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.addSubview(blurEffectView)
        
        view.addSubview(backgroundView)
        view.addSubview(uiImageView)
        
        uiImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        if let imageUrl = URL(string: imageUrl) {
            let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.5))
            Nuke.loadImage(with: imageUrl, options: options, into: uiImageView)
        }
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer()
        tap.rx.event
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
        backgroundView.addGestureRecognizer(tap)
        
        let pinch = UIPinchGestureRecognizer()
        pinch.rx.event
            .asDriver()
            .drive(onNext: { sender in
                sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
                sender.scale = 1.0
            })
            .disposed(by: disposeBag)
        
        uiImageView.addGestureRecognizer(pinch)
    }
}
