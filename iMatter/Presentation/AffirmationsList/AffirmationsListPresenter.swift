//
//  AffirmationsListPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/10/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class AffirmationsListPresenter: NSObject {
    var vcView: AffirmationsListViewController?
    init(vcView: AffirmationsListViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        AffirmationsListViewManager(presenter: self).build()
    }
}
