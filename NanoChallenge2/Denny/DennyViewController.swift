//
//  DennyViewController.swift
//  NanoChallenge2
//
//  Created by Denny Caruso on 08/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit

struct WebsiteDescription: Decodable {
    let name: String?
    let description: String?
    let courses: [Course]?
}


struct Course: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let imageURL: String?
    
//    init(json: [String: Any]) {
//        id = json["id"] as? Int ?? -1
//        name = json["id"] as? String ?? ""
//        link = json["id"] as? String ?? ""
//        imageURL = json["id"] as? String ?? ""
//    }
}

class DennyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonURL = "https://api.letsbuildthatapp.com/jsondecodable/courses_missing_fields"
        guard let myURL = URL(string: jsonURL) else { print("error 31"); return }
        
        URLSession.shared.dataTask(with: myURL) { (data, response, err) in
            print("hello")
            guard let data = data else { return }
//            let dataAsString = String(data: data!, encoding: .utf8)
            do {
                //swift 4
                let courses = try JSONDecoder().decode([Course].self, from: data)
                for item in courses {
                    print(item)
//                    print("Descrizione: \(item.description)")
//                    print("Corso: \(item.courses)")
                }
//                obj-c & Swift 2/3
//                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
//                let course = Course(json: json)
//                print(course.name)
                
            } catch let jsonError {
                print("Error serializin json", jsonError)
            }
        }.resume()
    }
}
