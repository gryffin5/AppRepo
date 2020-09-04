//
//  SignUpViewController.swift
//  catarACTION
//  Copyright 2020 Sruti Peddi. All rights reserved.
//


import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        //hides error label
        errorLabel.alpha = 0
        
        //Style signup elements
        Style.styleTextField(userNameTextField)
        Style.styleTextField(emailTextField)
        Style.styleTextField(passwordTextField)
        Style.styleFilledButton(signUpButton)
    }
    
    func validateFields() -> String? {
        
        //checks if all fields are filled
        if userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        //check if email is valid
        let trimmedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Style.emailIsValid(trimmedEmail) == false {
            return "Your email needs to be in a valid format"
        }
        //check if password is secure
        let trimmedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Style.passwordIsValid(trimmedPassword) == false {
            return "Your password needs to have at least 6 characters, a capital letter, a special character, and a number"
        }
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            //something's wrong, show error message
            showError(error!)
        }
        else {
            
            //create trimmed data
            let userName = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result,err) in
                
                //check for errors
                if err != nil {
                    //error creating user
                    self.showError(err?.localizedDescription ?? "Error creating user")
                }
                else {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = userName
                        print(userName)
                    changeRequest?.commitChanges { (error) in print ("Username not created") }

                    //transition to home screen
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
        
        let homeVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        self.view.window?.rootViewController = UINavigationController(rootViewController: homeVC!)
        self.view.window?.makeKeyAndVisible()
        
    }
}
