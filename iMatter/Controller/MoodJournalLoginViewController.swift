//
//  MoodJournalLoginViewController.swift
//  iMatter
//
//  Created by Mycah on 2/17/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit

class MoodJournalLoginViewController: UIViewController {

    @IBOutlet weak var signInBtnDisplay: UIButton!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up sign in button display
        signInBtnDisplay.layer.cornerRadius = 10
        
        emailInput.keyboardAppearance = .dark
        passwordInput.keyboardAppearance = .dark
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(_:)))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleScreenTap(_ sender: UITapGestureRecognizer){
        
        self.view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            self.view.frame.origin.y = -keyboardSize.height
           
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        print("\n\nPressed forgot password")
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Set up Keyboards
    
    
}
