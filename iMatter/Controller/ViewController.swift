//
//  ViewController.swift
//  iMatter
//
//  Created by Mycah on 11/1/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

//TODO: create an array of affirmations
//TODO: have the centerAffirmation.text change everyday using shared preference to save the day

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var articlesBtnDisplay: UIButton!
    @IBOutlet weak var affirmationsBtnDisplay: UIButton!
    @IBOutlet weak var affirmationsBuilderBtnDisplay: UIButton!
    @IBOutlet weak var daily5BtnDisplay: UIButton!
    @IBOutlet weak var centerAffirmation: UILabel!
    
    private var daily5Array : [AffirmationData] = [AffirmationData]()
    private var randomDaily5AudioString : String?
    private var randomDaily5Title : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
        
    }
    
    fileprivate func layoutSetup() {
        affirmationsBtnDisplay.layer.cornerRadius = 10
        affirmationsBuilderBtnDisplay.layer.cornerRadius = 10
        daily5BtnDisplay.layer.cornerRadius = 10
        articlesBtnDisplay.layer.cornerRadius = 10
        
        //        centerAffirmation.text = "Always Remember\nYou Matter"
        
        centerAffirmation.text = ListOfAffirmations().listOfAllAffirmations.randomElement()
        
        //fade in the text
        centerAffirmation.fadeIn()
    }
    
    @IBAction func daily5BtnPressed(_ sender: Any) {
        
        //Check Payment
        if true{
            
            //I need to pull all of the Daily 5 audio clips, then choose one randomly based on the amount returned
            RetrieveAffirmations().getAffirmations(apiPath: "daily_5" ,completion: { error,
                result in
                
                self.daily5Array = result
                
                let randomAffirmation = self.daily5Array.randomElement()
                self.randomDaily5AudioString = randomAffirmation?.audio
                self.randomDaily5Title = randomAffirmation?.title
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toDaily5Player", sender: sender)
                }
                
            })
            
        }else{
            performSegue(withIdentifier: "daily5ToIAP", sender: sender)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Need to grab random track from library
        if segue.identifier == "toDaily5Player"{
            
            let destVC = segue.destination as! AudioPlayerViewController
            destVC.stringURLRecieved = randomDaily5AudioString
            destVC.audioTitle = randomDaily5Title
            
        }
    }
}

