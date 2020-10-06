//
//  MoodJournalLoginViewController.swift
//  iMatter
//
//  Created by Mycah on 2/17/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit
import Firebase

class MoodJournalLoginViewController: UIViewController {

    @IBOutlet weak var signInBtnDisplay: UIButton!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var registerSigninSegmentDisplay: UISegmentedControl!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    let userDefaults = UserDefaults.standard
    var emailFromDefaults: String?
    var passwordFromDefaults: String?
    var didSaveDefaults: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up sign in button display
        signInBtnDisplay.layer.cornerRadius = 10
        
        emailInput.keyboardAppearance = .dark
        passwordInput.keyboardAppearance = .dark
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(_:)))
        self.view.addGestureRecognizer(tap)
        
        //Set Font colors of Segments
        let selectedSegmentAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        registerSigninSegmentDisplay.setTitleTextAttributes(selectedSegmentAttribute, for: .selected)
        let normalSegmentAttribute = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        registerSigninSegmentDisplay.setTitleTextAttributes(normalSegmentAttribute, for: .normal)
        
        
        //Get the email and password - if they are saved
        emailFromDefaults = userDefaults.string(forKey: "savedEmail")
        passwordFromDefaults = userDefaults.string(forKey: "savedPassword")
        
        didSaveDefaults = userDefaults.bool(forKey: "didSaveDefaults")
        if didSaveDefaults == true{
            rememberMeSwitch.isOn = true
        }else{
            rememberMeSwitch.isOn = false
        }
        emailInput.text = emailFromDefaults
        passwordInput.text = passwordFromDefaults
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func signInRegister(_ sender: Any) {
        
        //TODO: Save user Defaults if rememberMeBtn is on
        if rememberMeSwitch.isOn{
            //Save Data
            userDefaults.set(true, forKey: "didSaveDefaults")
            let enteredEmail = emailInput.text
            userDefaults.set(enteredEmail, forKey: "savedEmail")
            let enteredPassword = passwordInput.text
            userDefaults.set(enteredPassword, forKey: "savedPassword")
        }else{
            //Save empty defaults
            userDefaults.set("", forKey: "savedEmail")
            userDefaults.set("", forKey: "savedPassword")
            userDefaults.set(false, forKey: "didSaveDefaults")
        }
        
        if let email = emailInput.text, let password = passwordInput.text{
            
            if registerSigninSegmentDisplay.selectedSegmentIndex == 0{
                //Sign In
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    
                    if error != nil{
                        
                        //create alert for Error
                        let alertController = UIAlertController(title: nil, message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else{
                        
                        print("Signed in!")
                        print("\n\n\(user!.user.uid)\n\n")
                        
                        //Transition to Journal
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
                
            }else if registerSigninSegmentDisplay.selectedSegmentIndex == 1{
                
                //Register user
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    
                    if error != nil{
                        
                        //create alert for Error
                        let alertController = UIAlertController(title: nil, message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else{
                        if let user = user{
                            
                            //Transistion to Journal
                            self.dismiss(animated: true, completion: nil)
                        }
                        print("User Created!")
                    }
                }
            }
        }
        
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        //TODO: set this up
        performSegue(withIdentifier: "mjLoginToResetPassword", sender: self)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: keyboard
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            self.view.frame.origin.y = -keyboardSize.height
           
        }
    }
    
    @objc func handleScreenTap(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
}
