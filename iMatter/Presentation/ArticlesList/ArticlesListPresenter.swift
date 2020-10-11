//
//  ArticlesListPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/11/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class ArticlesListPresenter: NSObject {
    var vcView: ArticlesListViewController?
    init(vcView: ArticlesListViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        ArticlesListViewManager(presenter: self).build()
    }
}
