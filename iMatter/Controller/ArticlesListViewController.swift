//
//  ArticlesListViewController.swift
//  iMatter
//
//  Created by Mycah on 1/20/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit

class ArticlesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    private var articleArray : [ArticleData] = [ArticleData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "IMG_1057 copy"), for: .default)
        title = "Article List"
        
        //Set up delegates
        articleTableView.delegate = self
        articleTableView.dataSource = self
        
        retrieveArticleData()
        activitySpinner.startAnimating()
        
        //Set up the Cell for the Articles
        articleTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        
    }
    
    //MARK: - Tables
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = articleTableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        
        //Set up the Cell information
        cell.articleTitle.text = articleArray[indexPath.row].title
        cell.articleImage.imageFromServerURL(articleArray[indexPath.row].image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "articleListToArticleDisplay", sender: self)
    }
    
    fileprivate func retrieveArticleData(){
            
//        let url = URL(string: "http://rss.sciam.com/sciam/mind-and-brain")
        let url = URL(string: "https://tinybuddha.com/feed/")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          
            if error != nil{
                return
            }
            
            guard let xmlData = data else {return}
            
            //Convert data to string
            var s : String = String(data: xmlData, encoding: .utf8)!
            //Make XML conform to all standards
            s = s.replacingOccurrences(of: "\r", with: "\n")
            //Parse XML
            let articleParser = ArticleXMLParser(withXML: s)
            
            //Add the Parsed data to the articleArray
            self.articleArray = articleParser.parse()
            
            if self.articleArray.count == 0{
                DispatchQueue.main.async {
                    print("Unable to retrive articles")
                    self.articleTableView.reloadData()
                    self.activitySpinner.stopAnimating()
                }
            }else{
                DispatchQueue.main.async {
                    self.articleTableView.reloadData()
                    self.activitySpinner.stopAnimating()
                }
            }
            
        }
        task.resume()
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func infoBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "articleListToInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "articleListToArticleDisplay"{
            
            if let indexPath = articleTableView.indexPathForSelectedRow{
                let destVC = segue.destination as! ArticleDisplayViewController
                destVC.receivedArticleURL = articleArray[indexPath.row].link
                
                
                print("\n\n\(articleArray[indexPath.row].link)\n\n")
            }

        }else if segue.identifier == "articleListToInfo"{

            let destVC = segue.destination as! TermsAndPrivacyViewController
            destVC.receivedTitle = "Article List"

        }
    }
    
}
