//
//  ResetPasswordPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class ResetPasswordPresenter: NSObject {
    var vcView: ResetPasswordViewController?
    init(vcView: ResetPasswordViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        ResetPasswordViewManager(presenter: self).build()
    }
}
