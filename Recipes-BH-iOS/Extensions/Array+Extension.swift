//
//  Array+Extension.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import Foundation

extension Array {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        get {
            guard startIndex <= index && index < endIndex else {
                return nil
            }
            return self[index]
        }
        
        //Don't use this safe index setter for set nil value to array<Optional>
        set(newValue) {
            guard let solidValue = newValue, startIndex <= index && index < endIndex else {
                return
            }
            self[index] = solidValue
        }
    }
}
