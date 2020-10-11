//
//  MainPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/10/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class MainPresenter: NSObject {
    var vcView: ViewController?
    init(vcView: ViewController) {
        super.init()
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        MainViewManager(presenter: self).build()
    }
}
