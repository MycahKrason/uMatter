//
//  ArticleDisplayPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class ArticleDisplayPresenter: NSObject {
    var vcView: ArticleDisplayViewController?
    init(vcView: ArticleDisplayViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        ArticleDisplayViewManager(presenter: self).build()
    }
}
