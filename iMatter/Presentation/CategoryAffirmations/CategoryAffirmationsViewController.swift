//
//  CategoryAffirmationsViewController.swift
//  iMatter
//
//  Created by Mycah on 11/23/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

import UIKit

class CategoryAffirmationsViewController: UIViewController {
    @IBOutlet weak var motivationBtnDisplay: UIButton!
    @IBOutlet weak var anxietyBtnDisplay: UIButton!
    @IBOutlet weak var positivityBtnDisplay: UIButton!
    @IBOutlet weak var favoritesBtnDisplay: UIButton!
    @IBOutlet weak var confidenceBtnDisplay: UIButton!

    private var categoryToSend: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        CategoryAffirmationsPresenter(vcView: self).presentScene()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "IMG_1057 copy"), for: .default)
        title = "Affirmation Tracks"

        motivationBtnDisplay.layer.cornerRadius = 10
        anxietyBtnDisplay.layer.cornerRadius = 10
        positivityBtnDisplay.layer.cornerRadius = 10
        confidenceBtnDisplay.layer.cornerRadius = 10
        favoritesBtnDisplay.layer.cornerRadius = 10
    }

    @IBAction func categoryBtnSelected(_ sender: UIButton!) {
        //create function that sets a variable to be transferred in perform segue, then perform the segue
        performSegue(withIdentifier: "toAffirmationsList", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAffirmationsList"{
            guard let destVC = segue.destination as? AffirmationsListViewController else {return}
            if let buttonTitle = (sender as? UIButton)?.titleLabel?.text {
                destVC.recievedCategory = buttonTitle
            }
        }
    }

    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
