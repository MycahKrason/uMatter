//
//  InAppSubscriptionModalViewController.swift
//  iMatter
//
//  Created by Mycah on 12/2/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

import UIKit

class InAppSubscriptionModalViewController: UIViewController {
    @IBOutlet weak var monthlyInAppSubscriptionBtnDisplay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthlyInAppSubscriptionBtnDisplay.layer.cornerRadius = 10
    }
    
    @IBAction func inAppSubscriptionBtnPressed(_ sender: Any) {
        print("Clicked on Subscription")
    }
    
    @IBAction func termsOfUseAndPrivacyPolicyBtnPressed(_ sender: Any) {
        print("Clicked on Terms")
        performSegue(withIdentifier: "subscriptionToTermsPrivacy", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subscriptionToTermsPrivacy" {
            guard let destVC = segue.destination as? TermsAndPrivacyViewController else {return}
            destVC.receivedTitle = "Terms / Privacy Policy"
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
