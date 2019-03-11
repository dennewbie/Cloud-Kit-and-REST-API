//
//  HomepageViewController.swift
//  NanoChallenge2
//
//  Created by Luca Esposito on 07/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WebKit


class HomepageViewController: UIViewController {
    
    let movieDataModel = MovieDataModel()
    
    
    
    
    @IBOutlet var webTrailer: WKWebView!
    @IBOutlet var movieTextField: UITextField!
    @IBOutlet var imageMovie: UIImageView!
    @IBOutlet var nameMovie: UILabel!
    @IBOutlet var bigTitle: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var directorLabel: UILabel!
    @IBOutlet var actorLabel: UILabel!
    @IBOutlet var synopsisLabel: UILabel!
    

    @IBOutlet var rottenRatings: UILabel!
    @IBOutlet var imdbRatings: UILabel!
    @IBOutlet var metacriticRatings: UILabel!
    
    
    let MOVIE_URL = "https://www.omdbapi.com/?t="
    let APP_ID = "359b6059"
    let MOVIE_URL_TRAILER = "https://api.themoviedb.org/3/search/movie?api_key=b5679621226a4d43ac1b537cd157944d"
    let REVIEW_APP_ID = "lrP6pMI3XbnlTGowGyHNmqdRhUCRRGuM"
    var FINAL_URL = ""
    var FINAL_URL_TRAILER = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    func getMovieData(url: String, urlTrailer: String){
        
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess{
                print("Success we got Movie Data")
                let movieJSON : JSON = JSON(response.result.value!)
                self.updateMovieData(json: movieJSON)
            }else{
                print("Error \(String(describing:response.result.error))")
                self.imageMovie.image = UIImage(named: "No_Image_Available")
                self.nameMovie.text = "Not Found"
            }
        }
        
        Alamofire.request(urlTrailer, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                print("Success we got Movie Trailer Data")
                let trailerMovieJSON : JSON = JSON(response.result.value!)
                //                print(trailerMovieJSON)
                self.updateMovieTrailerData(json: trailerMovieJSON)
            }else{
                print("Error \(String(describing:response.result.error))")
            }
        }
    }
    
    func updateMovieData(json: JSON){
        
        if json["Title"] == ""{
            nameMovie.text = "Title Not Found"
            bigTitle.text = "Title Not Found"
        }else{
            movieDataModel.title = json["Title"].stringValue
            movieDataModel.bigTitle = json ["Title"].stringValue
            movieDataModel.poster = json["Poster"].stringValue
            movieDataModel.metacritic = json["Ratings"][2]["Value"].stringValue
            movieDataModel.imdb = json["Ratings"][0]["Value"].stringValue
            movieDataModel.rottenTomatoes = json["Ratings"][1]["Value"].stringValue
            movieDataModel.year = json["Year"].stringValue
            movieDataModel.genre = json["Genre"].stringValue
            movieDataModel.runtime = json["Runtime"].stringValue
            movieDataModel.director = json["Director"].stringValue
            movieDataModel.actors = json["Actors"].stringValue
            movieDataModel.plot = json["Plot"].stringValue
            
            updateUIWithMovieData()
            print(FINAL_URL)
            
        }
    }
    
    func updateUIWithMovieData(){
        
        nameMovie.text = movieDataModel.title
        bigTitle.text = movieDataModel.bigTitle
        rottenRatings.text = movieDataModel.rottenTomatoes
        imdbRatings.text = movieDataModel.imdb
        metacriticRatings.text = movieDataModel.metacritic
        yearLabel.text = movieDataModel.year
        genreLabel.text = movieDataModel.genre
        runtimeLabel.text = movieDataModel.runtime
        directorLabel.text = "Director: " + movieDataModel.director
        actorLabel.text = "Actors: " + movieDataModel.actors
        synopsisLabel.text = "Synopsis: \n" + movieDataModel.plot
        
        if movieDataModel.poster == "N/A"{
            self.imageMovie.image = UIImage(named: "No_Image_Available")
        }
        if let url = URL(string : movieDataModel.poster){
            do{
                let data = try Data(contentsOf: url)
                self.imageMovie.image = UIImage(data:data)
            }catch let err{
                print("Error : \(err.localizedDescription)")
            }
        }
    }
    
    func userEnteredANewMovieName(movie: String){
        
        FINAL_URL = MOVIE_URL + movie + "&apikey=" + APP_ID
        FINAL_URL_TRAILER = MOVIE_URL_TRAILER + "&query=" + movie
        getMovieData(url: FINAL_URL, urlTrailer: FINAL_URL_TRAILER)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let userMovieName = movieTextField.text!
        let movieName = userMovieName.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        userEnteredANewMovieName(movie: movieName)
        
    }
    
    func updateMovieTrailerData(json: JSON){
        //        if json["results"][0]["id"] == ""{
        //
        //            print("Trailer not Found")
        //        }else{
        let movieID = json["results"][0]["id"].stringValue
        let FINAL_SEARCH_URL_TRAILER = "https://api.themoviedb.org/3/movie/" + movieID + "/videos?api_key=b5679621226a4d43ac1b537cd157944d"
        print(FINAL_SEARCH_URL_TRAILER)
        Alamofire.request(FINAL_SEARCH_URL_TRAILER, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                print("Success we got final trailer!")
                let movieFinalTrailerJSON : JSON = JSON(response.result.value!)
                self.getVideo(json: movieFinalTrailerJSON)
            }else{
                print("Error \(String(describing:response.result.error))")
            }
        }
        
        //        }
    }
    
    func getVideo(json:JSON){
        
        if json["id"].double != nil {
            let videoCode = json["results"][0]["key"].stringValue
            let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
            webTrailer.load(URLRequest(url:url!))
        }else{
            print("Trailer Movie Not Found")
        }
        
    }
}







