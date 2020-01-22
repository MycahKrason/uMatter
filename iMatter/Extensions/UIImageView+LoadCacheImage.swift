//
//  UIImageView+LoadCacheImage.swift
//  iMatter
//
//  Created by Mycah on 1/21/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()


@objc extension UIImageView {

    
    func imageFromServerURL(_ URLString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if URLString == ""{
            
            return
        }

        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}

