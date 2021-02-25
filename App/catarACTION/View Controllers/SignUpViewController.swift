//
//  SignUpViewController.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 10/20/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//


import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
        self.userNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses Return Key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    func setUpElements() {
        // Hides error label
        errorLabel.alpha = 0
        
        // Style Signup elements
        Style.styleTextField(userNameTextField)
        Style.styleTextField(emailTextField)
        Style.styleTextField(passwordTextField)
        Style.styleFilledButton(signUpButton)
    }
    
    func validateFields() -> String? {
        
        // Checks if all fields are filled
        if userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        // Check if email is valid
        let trimmedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Style.emailIsValid(trimmedEmail) == false {
            return "Your email needs to be in a valid format"
        }
        // Check if password is secure
        let trimmedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Style.passwordIsValid(trimmedPassword) == false {
            return "Your password needs to have at least 6 characters, a capital letter, a special character, and a number"
        }
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // Something's wrong, show Error Message
            showError(error!)
        }
        else {
            
            // Create trimmed data
            let userName = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result,err) in
                
                // Check for errors
                if err != nil {
                    // Error creating user
                    self.showError(err?.localizedDescription ?? "Error creating user")
                }
                else {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = userName
                        print(userName)
                    changeRequest?.commitChanges { (error) in print ("Username not created") }

                    // Transition to home screen
                    self.saveLoggedState()
                    self.transitionHome()
                }
            }
        }
    }
    func showError(_ message:String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    func saveLoggedState() {
        
        let def = UserDefaults.standard
        def.set(true, forKey: "is_authenticated")
        def.synchronize()
        
    }
    func transitionHome() {
        
        hideKeyboard()
        let homeVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        self.view.window?.rootViewController = UINavigationController(rootViewController: homeVC!)
        self.view.window?.makeKeyAndVisible()
        
    }
}
