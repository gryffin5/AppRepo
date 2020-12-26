//
//  Style.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 10/23/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//

import UIKit
import Foundation

class Style{
    //styling for text fields
    static func styleTextField(_ textfield:UITextField) {
        
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width - 30, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1).cgColor
        
        textfield.borderStyle = .none
        
        textfield.layer.addSublayer(bottomLine)
        
    }
    //styling for full button
    static func styleFilledButton(_ button:UIButton) {
    
        button.backgroundColor = UIColor.init(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1)
        
        button.layer.cornerRadius = 25.0
        
        button.tintColor = UIColor.white
    }
    //styling for empty button
    static func styleHollowButton(_ button:UIButton) {
        
        button.layer.borderWidth = 2
        
        button.layer.borderColor = UIColor.init(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1).cgColor
        
        button.layer.cornerRadius = 25.0
        
        button.tintColor = UIColor.black
    }
    //checks password validity
    static func passwordIsValid(_ password: String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordTest.evaluate(with: password)
}
    //checks email validity
    static func emailIsValid(_ email: String) -> Bool {
           let regexEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
           let testEmail = NSPredicate(format:"SELF MATCHES %@", regexEmail)
           return testEmail.evaluate(with: email)
    }
}
