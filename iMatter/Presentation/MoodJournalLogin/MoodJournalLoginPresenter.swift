//
//  MoodJournalLoginPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class MoodJournalLoginPresenter: NSObject {
    var vcView: MoodJournalLoginViewController?
    init(vcView: MoodJournalLoginViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        MoodJournalLoginViewManager(presenter: self).build()
    }
}
