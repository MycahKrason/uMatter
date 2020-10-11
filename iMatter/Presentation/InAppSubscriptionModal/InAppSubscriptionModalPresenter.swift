//
//  InAppSubscriptionModalPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class InAppSubscriptionModalPresenter: NSObject {
    var vcView: InAppSubscriptionModalViewController?
    init(vcView: InAppSubscriptionModalViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        InAppSubscriptionModalViewManager(presenter: self).build()
    }
}
