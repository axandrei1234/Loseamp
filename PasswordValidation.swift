//
//  PasswordValidation.swift
//  loseamp
//
//  Created by Axente Andrei on 11.02.2023.
//

import Foundation

func isValidPassword(strToVailidate: String) -> Bool {
    let passwordValidationRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,40}$"
    
    let passwordValtiationPredeicate = NSPredicate(format: "SELF MATCHES %@", passwordValidationRegex)
    
    return passwordValtiationPredeicate.evaluate(with: strToVailidate)
}
