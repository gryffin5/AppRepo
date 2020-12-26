//
//  LoginViewController.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 10/20/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
        
    }
    
    func setUpElements (){
        // Hides error label
        errorLabel.alpha = 0
        // Sets up login elements
        Style.styleTextField(emailTextField)
        Style.styleTextField(passwordTextField)
        Style.styleHollowButton(loginButton)
    }
    
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        // Check if all fields are filled
        func validateFields() -> String? {
            if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
                return "Please fill in all fields"
            }
            return nil
        }
        // Trimmed Text Fields
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //signing in user
        Auth.auth().signIn(withEmail: email, password: password) {(result, error) in
            if error != nil {
                // Can't sign in
                self.errorLabel.text = "Unable to login user"
                self.errorLabel.alpha = 1
            }
            else {
                // User logs in successfully
                self.saveLoggedState()
                self.transitionHome()
            }
            
        }
        
    }
    func saveLoggedState() {
        
        let def = UserDefaults.standard
        // Save true flag to UserDefaults
        def.set(true, forKey: "is_authenticated")
        def.synchronize()
        
    }
    
    func transitionHome() {
        let homeVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        self.view.window?.rootViewController = UINavigationController(rootViewController: homeVC!)
        self.view.window?.makeKeyAndVisible()
    }
}
