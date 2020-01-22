//
//  ArticleDisplayViewController.swift
//  iMatter
//
//  Created by Mycah on 1/21/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit
import WebKit

class ArticleDisplayViewController: UIViewController {

    @IBOutlet weak var articleWebView: WKWebView!
    
    var receivedArticleURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let receivedArticleURLSafe = receivedArticleURL{
            let myURL = URL(string: receivedArticleURLSafe)
            let myRequest = URLRequest(url: myURL!)
            articleWebView.load(myRequest)
        }
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
