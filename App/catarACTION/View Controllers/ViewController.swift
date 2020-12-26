//
//  ViewController.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 10/20/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton?
    
    @IBOutlet weak var loginButton: UIButton?
    
    let defaultSignUpButton = UIButton(type: .infoDark)
    let defaultLoginButton = UIButton(type: .infoLight)
    
    override func viewDidLoad() {
        print("Shows; Line 19 in ViewController")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setUpElements() {
        // Styling Buttons
        Style.styleFilledButton(signUpButton ?? defaultSignUpButton)
        Style.styleHollowButton(loginButton ?? defaultLoginButton)
        
    }
    
}



