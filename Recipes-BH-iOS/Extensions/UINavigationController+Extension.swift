//
//  UINavigationController+Extension.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 09/11/23.
//

import Foundation
import UIKit

extension UINavigationController {
    func popViewController(animated: Bool, completion: (() -> Void)? = nil) {
        popViewController(animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }
}
