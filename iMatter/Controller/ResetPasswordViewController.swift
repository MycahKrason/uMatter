//
//  ResetPasswordViewController.swift
//  iMatter
//
//  Created by Mycah on 2/22/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailResetInput: UITextField!
    @IBOutlet weak var resetBtnDisplay: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(_:)))
        self.view.addGestureRecognizer(tap)
        
        resetBtnDisplay.layer.cornerRadius = 10
        
        emailResetInput.keyboardAppearance = .dark
        
    }
    
    @objc func handleScreenTap(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }

    @IBAction func closeViewBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        
        print("You pressed the forgot password button")

        //Make sure there is an eamil
        if emailResetInput.text != nil && !emailResetInput.text!.isEmpty{

            Auth.auth().sendPasswordReset(withEmail: emailResetInput.text!) { (err) in
                if err != nil{
                    //alert the user
                    print("unalble to update your password")
                    //show alert
                    let alertController = UIAlertController(title: nil, message: err?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                }else{

                    print("We are resetting your password")
                    //Alert the user and then dismiss the view
                    //show alert
                    let alertController = UIAlertController(title: nil, message:"Reset Password instructions have been sent to your email", preferredStyle: UIAlertController.Style.alert)
            
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default){ action -> Void in
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    })
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }
    }
}
