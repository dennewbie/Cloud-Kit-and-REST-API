//
//  FilmModel.swift
//  NanoChallenge2
//
//  Created by Vincenzo on 08/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import Foundation


struct Link : Decodable {
    var type : String
    var url : URL
    var suggested_link_text : String
    init(type :String, url : URL , textLink : String) {
        self.type =  type
        self.url = url
        self.suggested_link_text = textLink
    }
    
}


struct NYTReview : Decodable {
    var headline : String
    var link : Link
    
    init(title : String,link : Link) {
        self.headline =  title
        self.link = link
    }
    
}



struct NYTData : Decodable {
    var num_results : Int
    var results : [NYTReview]
    init(numResults : Int , results : [NYTReview]) {
        self.num_results = numResults
        self.results = results
    }
}
