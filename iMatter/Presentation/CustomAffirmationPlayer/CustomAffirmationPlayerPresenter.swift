//
//  CustomAffirmationPlayerPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class CustomAffirmationPlayerPresenter: NSObject {
    var vcView: CustomAffirmationPlayerViewController?
    init(vcView: CustomAffirmationPlayerViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        CustomAffirmationPlayerViewManager(presenter: self).build()
    }
}
