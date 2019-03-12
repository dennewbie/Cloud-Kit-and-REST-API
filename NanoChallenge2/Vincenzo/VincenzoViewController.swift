//
//  VincenzoViewController.swift
//  NanoChallenge2
//
//  Created by Vincenzo on 08/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import Foundation
import UIKit

class VincenzoViewController : UIViewController {
    @IBOutlet weak var listOfArticlesLabel: UILabel!
    //To show results
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    //To research
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
    var firstPartUrl = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?query="
    var lastPart = "&api-key=6PEmy4tZkSG8l0vVQ8W51yjq8htQTYtw"
    var openingDate : String?
    var articlesNumber = 0
    var articles = [NYTReview]()
    /*
     6PEmy4tZkSG8l0vVQ8W51yjq8htQTYtw api for the NYT
     Standard Url api type : https://api.nytimes.com/svc/movies/v2/reviews/search.json?query=KEYWORDHERE&api-key=66PEmy4tZkSG8l0vVQ8W51yjq8htQTYtw
     where keywordhere is the title or the keyword that you want to search for.
     
     Possible refinements :  &opening-date
     
     Sample of JSON result :
     {
     "status":"OK",
     "copyright":"Copyright (c) 2019 The New York Times Company. All Rights Reserved.",
     "has_more":false,
     "num_results":4,
     "results":[
     {
     "display_title":"Iron Man 3",
     "mpaa_rating":"PG-13",
     "critics_pick":0,
     "byline":"MANOHLA DARGIS",
     "headline":"Bang, Boom: Terrorism as a Game",
     "summary_short":"\u201cIron Man 3,\u201d with all its explosions so soon after the Boston Marathon bombings, underscores just how thoroughly terrorism and its aftermath have been colonized by the movies.",
     "publication_date":"2013-05-02",
     "opening_date":"2013-05-03",
     "date_updated":"2017-11-02 04:18:16",
     "link":{
     "type":"article",
     "url":"http:\/\/www.nytimes.com\/2013\/05\/03\/movies\/iron-man-3-with-robert-downey-jr.html",
     "suggested_link_text":"Read the New York Times Review of Iron Man 3"
     },
     "multimedia":null
     },
     {
     "display_title":"Iron Man 2",
     "mpaa_rating":"PG-13",
     "critics_pick":0,
     "byline":"A. O. SCOTT",
     "headline":"The Man in the Iron Irony",
     "summary_short":"The superhero sequel \u201cIron Man 2\u201d has been turned over to its game and gifted cast: Robert Downey Jr., Gwyneth Paltrow, Mickey Rourke, Scarlett Johansson and Samuel L. Jackson.",
     "publication_date":"2010-05-06",
     "opening_date":"2010-05-07",
     "date_updated":"2017-11-02 04:18:11",
     "link":{
     "type":"article",
     "url":"http:\/\/www.nytimes.com\/2010\/05\/07\/movies\/07iron.html",
     "suggested_link_text":"Read the New York Times Review of Iron Man 2"
     },
     "multimedia":null
     },
     {
     "display_title":"Iron Man",
     "mpaa_rating":"PG-13",
     "critics_pick":0,
     "byline":"A. O. SCOTT",
     "headline":"Heavy Suit, Light Touches",
     "summary_short":"\u201cIron Man\u201d is an unusually good superhero picture. Or at least \u2014 since it certainly has its problems \u2014 a superhero movie that\u2019s good in unusual ways.",
     "publication_date":"2008-05-02",
     "opening_date":"2008-05-02",
     "date_updated":"2017-11-02 04:18:07",
     "link":{
     "type":"article",
     "url":"http:\/\/www.nytimes.com\/2008\/05\/02\/movies\/02iron.html",
     "suggested_link_text":"Read the New York Times Review of Iron Man"
     },
     "multimedia":null
     },
     {
     "display_title":"Tetsuo: The Iron Man",
     "mpaa_rating":"Not Rated",
     "critics_pick":0,
     "byline":"STEPHEN HOLDEN",
     "headline":"TETSUO: THE IRON MAN (MOVIE)",
     "summary_short":"",
     "publication_date":"1992-04-22",
     "opening_date":null,
     "date_updated":"2017-11-02 04:16:09",
     "link":{
     "type":"article",
     "url":"http:\/\/www.nytimes.com\/1992\/04\/22\/movies\/review-film-forgoing-the-flesh-for-metallic-pleasures.html",
     "suggested_link_text":"Read the New York Times Review of Tetsuo: The Iron Man"
     },
     "multimedia":null
     }
     ]
     }
     
     
     
     
     */

    
    override func viewDidLoad() {
        articlesCollectionView.delegate = self
        articlesCollectionView.dataSource = self
        listOfArticlesLabel.isHidden = true
        self.searchButton.layer.cornerRadius = 15
        //Register a custom xib file for the cell
        articlesCollectionView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCell")
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    
    
    @IBAction func searchPressed(_ sender: Any) {
        self.searchButton.isHidden = true
        self.view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: self.searchButton.frame.midX, y: self.searchButton.frame.midY)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        let endPoint = firstPartUrl + textField.text! + lastPart
        startUrlSession(endPoint: endPoint)
    }
    
    
    func startUrlSession(endPoint : String) {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        //Build a safe url to reduce common writing errors
        let safeURLString = endPoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let endpointURL = URL(string: safeURLString!) else {
            print("The URL is invalid")
            return
        }
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "GET"
        /* Let the data task start, the queue is the operationqueue.main specified in the session, After being added to an operation queue, an operation remains in its queue until it reports that it is finished with its task. An operation queue executes its queued Operation objects based on their priority and readiness. 
         Parameters :
         data is The data returned by the server.
         response is An object that provides response metadata, such as HTTP headers and status code. If you are making an HTTP or HTTPS request, the returned object is actually an HTTPURLResponse object.
         error is An error object that indicates why the request failed, or nil if the request was successful.
         */
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            //Check if the json data have been downloaded.
            if(error == nil) {
                print(endPoint)
                let responseObject = response as! HTTPURLResponse
                switch responseObject.statusCode {
                case 200...299 :
                    print("Success")
                    break
                case 300...399:
                    print("Response is a redirection ")
                    break
                case 400...499:
                    print("Client error: ")
                    let alert = UIAlertController(title: "Client networking error", message: "This error can be due to some problems with the network. HTTP error code: \(responseObject.statusCode)", preferredStyle: .alert)
                    let okAct = UIAlertAction(title: "Ok", style: .default, handler: { (okAct) in
                        alert.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(okAct)
                    self.present(alert, animated: true, completion: nil)
                    print(responseObject.statusCode)
                    return
                default :
                    print("Something went wrong , server error code: ")
                    print(responseObject.statusCode)
                    let alert = UIAlertController(title: "Networking error", message: "This error can be due to some problems with the server. HTTP error code: \(responseObject.statusCode)", preferredStyle: .alert)
                    let okAct = UIAlertAction(title: "Ok", style: .default, handler: { (okAct) in
                        alert.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(okAct)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                guard let jsonData = data else {
                    print("The payload is invalid")
                    return
                }
                //Let te decode stuffs start.
                let decoder = JSONDecoder()
                do {
                
                    let articlesData = try decoder.decode(NYTData.self, from: jsonData)
                    print("Articles JSON decoded")
                    self.activityIndicator.stopAnimating()
                    self.searchButton.isHidden = false
                    self.articlesNumber = articlesData.num_results
                    if (self.articlesNumber > 0){
                        self.listOfArticlesLabel.isHidden = false
                        self.articles = articlesData.results
                        self.articlesCollectionView.reloadData()
                    }
                    else {
                        self.listOfArticlesLabel.isHidden = true
                        let alert = UIAlertController(title: "No results found!", message: "Try to change your keywords for this search. ", preferredStyle: .alert)
                        let okAct = UIAlertAction(title: "Ok", style: .default, handler: { (okAct) in
                            alert.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(okAct)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                //Catch possible errors in decoding
                catch let errorFound {
                    print("weather JSON decoding failed.")
                    print(errorFound)
                }
            }
            else {
                //We are here if something , not related to the http request, went wrong. For example : no internet connection
                print(error)
                let alert = UIAlertController(title: "Networking error", message: "This error can be due to the absence of data connection. ", preferredStyle: .alert)
                let okAct = UIAlertAction(title: "Ok", style: .default, handler: { (okAct) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okAct)
                self.present(alert, animated: true, completion: nil)
            }
        }
        dataTask.resume()

    }
    
    
}




extension VincenzoViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        if(articlesNumber > 0){
            var shorterDescription = ""
            if (self.articles[indexPath.row].link.suggested_link_text.contains("Read the New York Times ")){
                shorterDescription = self.articles[indexPath.row].link.suggested_link_text.replacingOccurrences(of: "Read the New York Times ", with: "")
                cell.linkButton.setTitle(shorterDescription, for: .normal)
            }
            cell.typeLabel.text = self.articles[indexPath.row].link.type.uppercased() + ":"
            cell.articleLink = self.articles[indexPath.row].link.url
            if ( self.articles[indexPath.row].multimedia?.src != nil){
                cell.previewImage.dowloadFromServer(link: self.articles[indexPath.row].multimedia!.src, contentMode: .scaleAspectFit)
                cell.imageLink = self.articles[indexPath.row].multimedia!.src
                }
            else {
                cell.previewImage.dowloadFromServer(link: "http://www.nytimes.com/services/mobile/img/ios-newsreader-icon.png", contentMode: .scaleAspectFit)
                cell.imageLink = "http://www.nytimes.com/services/mobile/img/ios-newsreader-icon.png" 
            }
        }
        return cell
    }
    
    
    
    
}

extension VincenzoViewController : UICollectionViewDelegate {
    
    
}



