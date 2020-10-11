//
//  ViewController.swift
//  iMatter
//
//  Created by Mycah on 11/1/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var articlesBtnDisplay: UIButton!
    @IBOutlet weak var affirmationsBtnDisplay: UIButton!
    @IBOutlet weak var affirmationsBuilderBtnDisplay: UIButton!
    @IBOutlet weak var daily5BtnDisplay: UIButton!
    @IBOutlet weak var centerAffirmation: UILabel!
    @IBOutlet weak var moodJournalBtnDisplay: UIButton!

    private var daily5Array: [AffirmationData] = [AffirmationData]()
    private var randomDaily5AudioString: String?
    private var randomDaily5Title: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        layoutSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        pulsateBtn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.daily5BtnDisplay.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }

    func pulsateBtn() {
        //Pulsate the button
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            self.daily5BtnDisplay.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
        }, completion: nil)
    }

    fileprivate func layoutSetup() {
        affirmationsBtnDisplay.layer.cornerRadius = 10
        affirmationsBuilderBtnDisplay.layer.cornerRadius = 10
        daily5BtnDisplay.layer.cornerRadius = 10
        articlesBtnDisplay.layer.cornerRadius = 10
        moodJournalBtnDisplay.layer.cornerRadius = 10
        centerAffirmation.text = ListOfAffirmations().listOfAllAffirmations.randomElement()

        //fade in the text
        centerAffirmation.fadeIn()
    }

    @IBAction func daily5BtnPressed(_ sender: Any) {
        //Check Payment
        if true {
            //I need to pull all of the Daily 5 audio clips, then choose one randomly based on the amount returned
            RetrieveAffirmations().getAffirmations(apiPath: "daily_5", completion: { _, result in
                self.daily5Array = result
                let randomAffirmation = self.daily5Array.randomElement()
                self.randomDaily5AudioString = randomAffirmation?.audio
                self.randomDaily5Title = randomAffirmation?.title

                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toDaily5Player", sender: sender)
                }
            })
        }
        //        else {
        //            performSegue(withIdentifier: "daily5ToIAP", sender: sender)
        //        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Need to grab random track from library
        if segue.identifier == "toDaily5Player"{
            guard let destVC = segue.destination as? AudioPlayerViewController else {return}
            destVC.stringURLRecieved = randomDaily5AudioString
            destVC.audioTitle = randomDaily5Title
        }
    }
}
