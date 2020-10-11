//
//  TermsAndPrivacyPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class TermsAndPrivacyPresenter: NSObject {
    var vcView: TermsAndPrivacyViewController?
    init(vcView: TermsAndPrivacyViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        TermsAndPrivacyViewManager(presenter: self).build()
    }
}
