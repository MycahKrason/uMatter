//
//  MoodJournalSelectionViewManager.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class MoodJournalSelectionViewManager {
    var presenter: MoodJournalSelectionPresenter?
    init(presenter: MoodJournalSelectionPresenter) {
        self.presenter = presenter
    }

    func build() {
        print("\nYou are building with the MainViewManager\n")
    }
}
