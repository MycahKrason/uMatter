//
//  ArticleXMLParser.swift
//  iMatter
//
//  Created by Mycah on 1/20/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation

class ArticleXMLParser: NSObject, XMLParserDelegate{
    
    var xmlParser: XMLParser?
    var articles: [ArticleData] = []
    var xmlText : String = ""
    var currentArticle: ArticleData?
    
    init(withXML xml: String){
        if let data = xml.data(using: String.Encoding.utf8){
            xmlParser = XMLParser(data: data)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        xmlText = ""
        if elementName == "item"{
            currentArticle = ArticleData()
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "title"{
            currentArticle?.title = xmlText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "link"{
            currentArticle?.link = xmlText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
        
        //This will grab the image
        if elementName == "description"{
            
            currentArticle?.image = xmlText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).slice(from: "src=\"", to: "\"")!
            
        }
        
        if elementName == "item"{
            if let article = currentArticle{
                articles.append(article)
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText += string
    }
    
    
    
    func parse() -> [ArticleData]{
        xmlParser?.delegate = self
        xmlParser?.parse()
        return articles
    }
    
}




extension String {

    func slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
