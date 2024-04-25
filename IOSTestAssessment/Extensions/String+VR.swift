//
//  String+VR.swift
//  IOSTestAssessment
//
//  Created by Rajan on 26/04/24.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        // Capitalize the first letter of the string
        let firstLetterCapitalized = self.prefix(1).uppercased() + self.dropFirst()
        return firstLetterCapitalized
    }
}
