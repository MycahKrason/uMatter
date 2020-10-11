//
//  MoodJournalSelectionPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class MoodJournalSelectionPresenter: NSObject {
    var vcView: MoodJournalSelectionViewController?
    init(vcView: MoodJournalSelectionViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        MoodJournalSelectionViewManager(presenter: self).build()
    }
}
