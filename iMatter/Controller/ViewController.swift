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
    
    @IBOutlet weak var affirmationsBtnDisplay: UIButton!
    @IBOutlet weak var affirmationsBuilderBtnDisplay: UIButton!
    @IBOutlet weak var daily5BtnDisplay: UIButton!
    @IBOutlet weak var centerAffirmation: UILabel!
    
    var daily5Array : [AffirmationData] = [AffirmationData]()
    var randomDaily5AudioString : String?
    var randomDaily5Title : String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        affirmationsBtnDisplay.layer.cornerRadius = 10
        affirmationsBuilderBtnDisplay.layer.cornerRadius = 10
        daily5BtnDisplay.layer.cornerRadius = 10
        
//        centerAffirmation.text = "Always Remember\nYou Matter"
        
        
        centerAffirmation.text = ListOfAffirmations().listOfAllAffirmations.randomElement()
        
        //TODO: fade in the text
        centerAffirmation.fadeIn()
        // Do any additional setup after loading the view.
        
        var testArray : [String] = ["one", "two", "three", "three"]
        print(testArray.count)
        
        var setArray : Set = Set(testArray)
        print(setArray)
        
         
    }
    
    @IBAction func daily5BtnPressed(_ sender: Any) {
        
        //Check Payment
        if true{
            
            //I need to pull all of the Daily 5 audio clips
            //then choose one randomly based on the amount returned
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

extension UIView {
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 1.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
            }, completion: nil)
    }

    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
}

