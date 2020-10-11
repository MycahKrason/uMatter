//
//  InfoButtonView.swift
//  iMatter
//
//  Created by Mycah Krason on 10/9/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit

class InfoButtonView: NSObject {
    var vcView: UIViewController
    var segueIdentifier: String

    init(vcView: UIViewController, segueIdentifier: String) {
        self.vcView = vcView
        self.segueIdentifier = segueIdentifier
    }

    func addInfoButton() {
        let infoButton = UIBarButtonItem.init(image: UIImage(systemName: "info.circle"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(segueToInfo))
        vcView.navigationItem.rightBarButtonItem = infoButton
        print("\n\nSetUp the info\n\n")
    }

    @objc func segueToInfo() {
        vcView.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}
