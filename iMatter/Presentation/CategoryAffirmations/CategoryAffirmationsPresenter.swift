//
//  CategoryAffirmationsPresenter.swift
//  iMatter
//
//  Created by Mycah Krason on 10/10/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class CategoryAffirmationsPresenter: NSObject {
    var vcView: CategoryAffirmationsViewController?
    init(vcView: CategoryAffirmationsViewController) {
        self.vcView = vcView
    }

    func presentScene() {
        print("\n\nYou are presenting the scene\n\n")
        CategoryAffirmationsViewManager(presenter: self).build()
    }
}
