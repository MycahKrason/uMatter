//
//  MoodJournalSelectionViewController.swift
//  iMatter
//
//  Created by Mycah on 2/17/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit

class MoodJournalSelectionViewController: UIViewController {

    @IBOutlet weak var loginBtnDisplay: UIButton!
    @IBOutlet weak var addJournalEntryDisplay: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up buttons
        loginBtnDisplay.layer.cornerRadius = 10
        addJournalEntryDisplay.layer.cornerRadius = 10
        
    }
    
    @IBAction func addJournalEntry(_ sender: Any) {
        
    }
    
    @IBAction func loginLogoutBtnPressed(_ sender: Any) {
        //To login
        performSegue(withIdentifier: "moodJournalToSignIn", sender: self)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
