//
//  UIView+Fades.swift
//  iMatter
//
//  Created by Mycah on 1/23/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 1.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 
            }, completion: nil)
    }

    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
    
    
}
