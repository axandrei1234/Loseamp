//
//  EmailValidation.swift
//  loseamp
//
//  Created by Axente Andrei on 06.02.2023.
//

import Foundation

func isValidEmailAddr(strToValidate: String) -> Bool {
    let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
    
    let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
    
    return emailValidationPredicate.evaluate(with: strToValidate)
}
