//
//  MoodJournalEntryFormPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class MoodJournalEntryFormPresenter: NSObject {
    var vcView: MoodJournalEntryFormViewController?
    init(vcView: MoodJournalEntryFormViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        MoodJournalEntryFormViewManager(presenter: self).build()
    }
}
