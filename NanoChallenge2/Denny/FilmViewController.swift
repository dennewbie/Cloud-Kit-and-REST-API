//
//  FilmViewController.swift
//  NanoChallenge2
//
//  Created by Denny Caruso on 08/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit
import SystemConfiguration

struct Film: Decodable {
    let Title: String
    let Year: String
    let Rated: String
    let Released: String
    let Runtime: String
    let Genre: String
    let Director: String
    let Writer: String
    let Actors: String
    let Plot: String
    let Language: String
    let Country: String
    let Awards: String
    let Poster: String
    let Ratings: [Ratings]
    let imdbRating: String
    let DVD: String
    let BoxOffice: String
    let Production: String
    let Website: String
}

struct Ratings: Decodable {
    let Source: String
    let Value: String
}

class FilmViewController: UIViewController, UITextFieldDelegate {

    let scrollViewFilm: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()

    private var titleLabel = UILabel()
    private var searchFilmTextField = UITextField()
    private var searchButton = UIButton()
    private var resultLabel = UILabel()
    let roundesSquare = UIView()
    private var posterImage = UIImageView()
    private var preResultLabel = UILabel()
    private var textFieldDate = UITextField()
    let calendarOnlyYear = YearPickerView()
    private var yearLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupTitleLabel()
        setupResultLabel()
        setupTextField()
        setupDatePicker()
        setupButton()
    }
    
    private func setupScrollView() {
        self.view.addSubview(scrollViewFilm)
    
        scrollViewFilm.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        scrollViewFilm.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0).isActive = true
        scrollViewFilm.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        scrollViewFilm.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
        scrollViewFilm.contentSize = CGSize(width: (self.view.frame.width - 20), height: (self.view.frame.height) + 1200)
    }
    
    private func setupTitleLabel() {
        titleLabel.frame = CGRect(x: 20, y: 30, width: 100, height: 50)
        titleLabel.text = "Title"
        titleLabel.font = titleLabel.font.withSize(20)
        titleLabel.layer.cornerRadius = 15
        titleLabel.layer.masksToBounds = true
        titleLabel.textColor = .black
        
        yearLabel.frame = CGRect(x: 20, y: 140, width: self.view.frame.width, height: 30)
        yearLabel.text = "Year"
        yearLabel.font = titleLabel.font.withSize(20)
        yearLabel.layer.cornerRadius = 15
        yearLabel.layer.masksToBounds = true
        yearLabel.textColor = .black
        
        scrollViewFilm.addSubview(titleLabel)
        scrollViewFilm.addSubview(yearLabel)
    }
    
    private func setupTextField() {
        searchFilmTextField.frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 100, height: 30)
        searchFilmTextField.placeholder = "Write here a title film..."
        searchFilmTextField.borderStyle = .roundedRect
        searchFilmTextField.minimumFontSize = 20
        searchFilmTextField.layer.cornerRadius = 15
        searchFilmTextField.returnKeyType = .done
        
        scrollViewFilm.addSubview(searchFilmTextField)
    }
    
    private func setupDatePicker(){
        createGestureRecognizer()
        
        textFieldDate.frame = CGRect(x: 20, y: 180, width: self.view.frame.width - 100, height: 30)
        textFieldDate.placeholder = "Optional: Choose a year..."
        textFieldDate.resignFirstResponder()
        textFieldDate.inputView = calendarOnlyYear
        textFieldDate.borderStyle = .roundedRect
        textFieldDate.delegate = self
        
        calendarOnlyYear.onDateSelected = { (year: Int) in
            let string = String(format: "%02d", year)
            self.textFieldDate.text = "\(string)"
            
        }
        scrollViewFilm.addSubview(textFieldDate)
    }
    
    private func createGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissViewOnTapGesture(gestureRecognizer:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func dismissViewOnTapGesture(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    private func setupButton() {
        searchButton.frame = CGRect(x: self.view.center.x - 150, y: self.view.frame.minY + 250, width: 300, height: 50)
        searchButton.backgroundColor = .black
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.white, for: .normal )
        searchButton.layer.cornerRadius = 15
        searchButton.addTarget(self, action: #selector(searchForFilm), for: .touchUpInside)
        
        scrollViewFilm.addSubview(searchButton)
    }
    
    private func setupResultLabel() {
        roundesSquare.frame = CGRect(x: 20, y: (self.view.frame.height / 2) - 100, width: self.view.frame.width - 50, height: (self.view.frame.height) + 750)
        roundesSquare.backgroundColor = UIColor.black
        roundesSquare.layer.cornerRadius = 15
        
        resultLabel.frame = CGRect(x: 10, y: posterImage.frame.maxY + 80, width: roundesSquare.frame.width - 5, height: roundesSquare.frame.height)
        
        resultLabel.text = "Here you will see the result..."
        resultLabel.font = titleLabel.font.withSize(20)
        resultLabel.numberOfLines = 50
        resultLabel.textColor = .white
        
        
        
        preResultLabel.frame = CGRect(x: self.view.frame.width / 2 - 70 , y: 10, width: 100, height: 30)
        preResultLabel.textAlignment = .center
        preResultLabel.text = "Result"
        preResultLabel.textColor = .white
        
        roundesSquare.addSubview(preResultLabel)
        roundesSquare.addSubview(resultLabel)
        scrollViewFilm.addSubview(roundesSquare)
    }
    
    @objc private func searchForFilm() {
        var jsonURL = "https://www.omdbapi.com/?t="
        print(jsonURL)
        if searchFilmTextField.text == "" {
            let errorAlert = UIAlertController(title: "Error", message: "Please insert a valid title.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(errorAlert, animated: true)
        } else {
            if textFieldDate.text != "" {
                
                let generateUserFilm = searchFilmTextField.text
                let generateUserDate = "&y=\(textFieldDate.text!)"
                let filteredFilm = generateUserFilm!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
                jsonURL.append(filteredFilm)
                jsonURL.append(generateUserDate)
                jsonURL.append("&apikey=5f784705")
            } else {
                let generateUserFilm = searchFilmTextField.text
                let filteredFilm = generateUserFilm!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
                jsonURL.append(filteredFilm)
                jsonURL.append("&apikey=5f784705")
            }
        }
        
        print(jsonURL)
        
        guard let myURL = URL(string: jsonURL) else { print("Error URL"); return }
        
        URLSession.shared.dataTask(with: myURL) { (data, response, err) in
            guard let data = data else {
                DispatchQueue.main.async {
                    let errorAlert = UIAlertController(title: "Error", message: "Ops... There's a problem with internet connection or the server is offline.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(errorAlert, animated: true)
                }
                return }
            do {
                let films = try JSONDecoder().decode(Film.self, from: data)
                print(films)
                DispatchQueue.main.async {
                    self.updateResultLabel(films: films)
                }
            } catch let jsonError {
                print("Error serializin json", jsonError)
                DispatchQueue.main.async {
                    self.errorUpdateLabel()
                }
            }
            }.resume()
    }
    
    private func updateResultLabel(films: Film) {
        
        resultLabel.text = "Title: \(films.Title)\nYear: \(films.Year)\nRated: \(films.Rated)\nReleased: \(films.Released)\n\nRuntime: \(films.Runtime)\nGenre: \(films.Genre)\nDirector: \(films.Director)\nWriter: \(films.Writer)\nActors: \(films.Actors)\n\nPlot: \(films.Plot)\nLanguage: \(films.Language)\nAwards: \(films.Awards)\nIMDB Rating: \(films.imdbRating)\nDVD: \(films.DVD)\nBoxOffice: \(films.BoxOffice)\nProduction: \(films.Production)\nWebsite: \(films.Website)\n\n\t\t\t\tRatings\n"
        for rating in films.Ratings {
            resultLabel.text?.append("Source: \(rating.Source)\nValue: \(rating.Value)\n\n")
        }
        
        posterImage.frame = CGRect(x: self.view.center.x / 2 - 20, y: roundesSquare.frame.minY - 300 , width: 200, height: 250)
        
        
        let urlImage = URL(string: "\(films.Poster)")!
        var dataImage = Data()
        do {
            dataImage = try Data (contentsOf: urlImage)
        }catch{
            print("Errore downlaod")
            resultLabel.text = "Errore nel download dell'immagine.\n\n\(resultLabel.text!)"
        }
        posterImage.image = UIImage(data: dataImage)
        posterImage.layer.cornerRadius = 15
        posterImage.layer.masksToBounds = true
        
        roundesSquare.addSubview(posterImage)
    }
    
    private func errorUpdateLabel() {
        resultLabel.text = "There was an error searching for this film... Check what you wrote.\nMaybe the server is off, try later."
        posterImage.removeFromSuperview()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
