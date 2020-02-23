//
//  MoodJournalEntryFormViewController.swift
//  iMatter
//
//  Created by Mycah on 2/21/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit
import Firebase

class MoodJournalEntryFormViewController: UIViewController {

    @IBOutlet weak var entryTextInput: UITextView!
    @IBOutlet weak var submitBtnDisplay: UIButton!
    
    //Mood Buttons
    @IBOutlet weak var verySad: UIButton!
    @IBOutlet weak var sad: UIButton!
    @IBOutlet weak var normal: UIButton!
    @IBOutlet weak var happy: UIButton!
    @IBOutlet weak var veryHappy: UIButton!
    
    var moodSelected: String?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up UI Corner Radius
        submitBtnDisplay.layer.cornerRadius = 10
        entryTextInput.layer.cornerRadius = 5
        
        verySad.layer.cornerRadius = 10
        sad.layer.cornerRadius = 10
        normal.layer.cornerRadius = 10
        happy.layer.cornerRadius = 10
        veryHappy.layer.cornerRadius = 10
        
        //Set keyboard color
        entryTextInput.keyboardAppearance = .dark
        
        //Set up tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(_:)))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func submitEntryBtnPressed(_ sender: Any) {

        //do a check to ensure that the entry is set and a mood has been chosen
        guard let entryText = entryTextInput.text else {return}
        guard let chosenMood = moodSelected else {
            
            //show alert
            let alertController = UIAlertController(title: nil, message:"Please choose a mood.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
            
        }
        
        //Get Time
        let dateTimePosted = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
        
        //grab the user
        if let userId = Auth.auth().currentUser?.uid {
            
            db.collection("Users").document(userId).collection("JournalEntries").addDocument(data: ["entry": entryText, "mood": chosenMood, "date": dateTimePosted, "sortTime": Date()]) { (err) in
                
                print("New Entry has been added")
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleScreenTap(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBAction func moodBtnPressed(_ sender: UIButton) {
        
        //Remove all highlights
        verySad.backgroundColor = .black
        sad.backgroundColor = .black
        normal.backgroundColor = .black
        happy.backgroundColor = .black
        veryHappy.backgroundColor = .black
        
        let btnTag = sender.tag
        switch btnTag {
        case 0:
            verySad.backgroundColor = .darkGray
            moodSelected = "\(moodOptions.verySad)"
        case 1:
            sad.backgroundColor = .darkGray
            moodSelected = "\(moodOptions.sad)"
        case 2:
            normal.backgroundColor = .darkGray
            moodSelected = "\(moodOptions.normal)"
        case 3:
            happy.backgroundColor = .darkGray
            moodSelected = "\(moodOptions.happy)"
        case 4:
            veryHappy.backgroundColor = .darkGray
            moodSelected = "\(moodOptions.veryHappy)"
        default: break
            
        }
    }
    
    fileprivate enum moodOptions{
        case verySad
        case sad
        case normal
        case happy
        case veryHappy
    }
    
}