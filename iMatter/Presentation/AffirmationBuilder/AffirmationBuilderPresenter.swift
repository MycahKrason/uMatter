//
//  AffirmationBuilderPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class AffirmationBuilderPresenter: NSObject {
    var vcView: AffirmationBuilderViewController?
    init(vcView: AffirmationBuilderViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        AffirmationBuilderViewManager(presenter: self).build()
    }
}
