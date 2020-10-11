//
//  AudioPlayerPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class AudioPlayerPresenter: NSObject {
    var vcView: AudioPlayerViewController?
    init(vcView: AudioPlayerViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        AudioPlayerViewManager(presenter: self).build()
    }
}
