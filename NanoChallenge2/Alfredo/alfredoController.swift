//
//  alfredoController.swift
//  NanoChallenge2
//
//  Created by Alfredo Fiore on 12/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit

class alfredoController: UIViewController {

    @IBOutlet weak var titoloField: UITextField!
    @IBOutlet weak var attoriArea: UITextView!
    @IBOutlet weak var registaField: UITextField!
    @IBOutlet weak var genereArea: UITextView!
    @IBOutlet weak var errore: UILabel!
    
    struct UserPost : Codable {
        var userId: Int?
        var id: Int?
        var title: String?
        var body: String?
        
    }
    
    
    
    func controlloTitolo ( titolo: String) -> String {
        let testo = titolo
        let newString: String = testo.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        return newString
    }
    
    override func viewDidLoad() {
        
        //
        //        let data = richiestaFilm(forTitoloFilm: "Iron%20Man")
        //
        ////        print(data)
        //        let json = json_parseData(data!)
        //
        ////        print(json)
        //
        //        let attori: NSString = (json!["Actors"] as? NSString)!
        
        
        
        //        print("attori del film = ", attori)
        //        let weather: NSDictionary = weather_array[0] as! NSDictionary
        
    }
    @IBAction func cercaAction(_ sender: UIButton) {
        
        
        let data = richiestaFilm(forTitoloFilm: controlloTitolo(titolo: titoloField.text!))
        let json = json_parseData(data!)
        let Response: String = (json!["Response"] as? NSString)! as String
        
        if (Response=="True"){
            errore.isHidden=true
            
            let attori: NSString = (json!["Actors"] as? NSString)!
            let regista : NSString = (json!["Director"] as? NSString)!
            let genere : NSString = (json!["Genre"] as? NSString)!
            
            attoriArea.text = attori as String
            registaField.text = regista as String
            genereArea.text = genere as String
        }
        else{
            errore.isHidden=false
        }
    }
    
    // funzione per il download della pagina dato un URL e conseguente conversione del download in Data
    
    func richiestaFilm(forTitoloFilm: String) -> Data? {
        let api_key = "6a98a49a" // chiave per il sito
        guard let url = URL(string: "http://www.omdbapi.com/?t=\(forTitoloFilm)&apikey=\(api_key)") else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("[ERROR] There is an unspecified error with the connection")
            return nil
        }
        
        print("[CONNECTION] OK, data correctly downloaded")
        return data
    }
    
    // funzione per la generazione del json a partire da un Data
    func json_parseData(_ data: Data) -> NSDictionary? {
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            print("[JSON] OK!")
            print(json)
            return (json as? NSDictionary)
        } catch _ {
            print("[ERROR] An error has happened with parsing of json data")
            return nil
        }
        
    }

}
