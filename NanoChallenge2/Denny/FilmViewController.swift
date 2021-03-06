//
//  FilmViewController.swift
//  NanoChallenge2
//
//  Created by Denny Caruso on 08/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit
import SystemConfiguration
import CloudKit


let databaseFilm = CKContainer.default().publicCloudDatabase
var generatedUserFilm = String()


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
    let DVD: String?
    let BoxOffice: String?
    let Production: String?
    let Website: String?
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
    
    var temp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupTitleLabel()
        setupResultLabel()
        setupTextField()
        setupDatePicker()
        setupButton()
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    private func setupScrollView() {
        self.view.addSubview(scrollViewFilm)
    
        scrollViewFilm.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        scrollViewFilm.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0).isActive = true
        scrollViewFilm.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        scrollViewFilm.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
        scrollViewFilm.contentSize = CGSize(width: (self.view.frame.width - 20), height: (self.view.frame.height) + 1100)
    }
    
    private func setupTitleLabel() {
        titleLabel.frame = CGRect(x: 20, y: 20, width: self.view.frame.width, height: 50)
        titleLabel.text = "Title"
        titleLabel.font = titleLabel.font.withSize(20)
        titleLabel.layer.cornerRadius = 15
        titleLabel.layer.masksToBounds = true
        titleLabel.textColor = .black
        
        yearLabel.frame = CGRect(x: 20, y: 120, width: self.view.frame.width, height: 50)
        yearLabel.text = "Year"
        yearLabel.font = titleLabel.font.withSize(20)
        yearLabel.layer.cornerRadius = 15
        yearLabel.layer.masksToBounds = true
        yearLabel.textColor = .black
        
        scrollViewFilm.addSubview(titleLabel)
        scrollViewFilm.addSubview(yearLabel)
    }
    
    private func setupTextField() {
        searchFilmTextField.frame = CGRect(x: 20, y: 70, width: self.view.frame.width - 60, height: 40)
        searchFilmTextField.placeholder = "Write here a title film..."
        searchFilmTextField.borderStyle = .roundedRect
        searchFilmTextField.minimumFontSize = 20
        searchFilmTextField.layer.cornerRadius = 15
        searchFilmTextField.returnKeyType = .done
        searchFilmTextField.clearButtonMode = .always
        
        scrollViewFilm.addSubview(searchFilmTextField)
    }
    
    private func setupDatePicker(){
        createGestureRecognizer()
        
        textFieldDate.frame = CGRect(x: 20, y: 180, width: self.view.frame.width - 60, height: 40)
        textFieldDate.placeholder = "Optional: Choose a year..."
        textFieldDate.resignFirstResponder()
        textFieldDate.clearButtonMode = .always
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        
        
        let cancelButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(dismissPicker))
        toolBar.setItems([cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textFieldDate.inputAccessoryView = toolBar
        
        
        
        textFieldDate.inputView = calendarOnlyYear
        textFieldDate.borderStyle = .roundedRect
        textFieldDate.delegate = self
        calendarOnlyYear.showsSelectionIndicator = true
        calendarOnlyYear.onDateSelected = { (year: Int) in
            let string = String(format: "%02d", year)
            self.textFieldDate.text = "\(string)"
        }
        scrollViewFilm.addSubview(textFieldDate)
    }
    
    @objc private func dismissPicker() {
        self.view.endEditing(true)
        textFieldDate.text = ""
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
                
                let generatedUserFilm = searchFilmTextField.text
                let generatedUserDate = "&y=\(textFieldDate.text!)"
                let filteredFilm = generatedUserFilm!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
                jsonURL.append(filteredFilm)
                jsonURL.append(generatedUserDate)
                jsonURL.append("&apikey=5f784705")
            } else {
                generatedUserFilm = searchFilmTextField.text!
                let filteredFilm = generatedUserFilm.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
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
//                print(films)
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
        
        resultLabel.text = "Title: \(films.Title)\nYear: \(films.Year)\nRated: \(films.Rated)\nReleased: \(films.Released)\n\nRuntime: \(films.Runtime)\nGenre: \(films.Genre)\nDirector: \(films.Director)\nWriter: \(films.Writer)\nActors: \(films.Actors)\n\nPlot: \(films.Plot)\nLanguage: \(films.Language)\nAwards: \(films.Awards)\nIMDB Rating: \(films.imdbRating ?? "N/A")\nDVD: \(films.DVD ?? "N/A")\nBoxOffice: \(films.BoxOffice ?? "N/A")\nProduction: \(films.Production ?? "N/A")\nWebsite: \(films.Website ?? "N/A")\n\n\t\t\t\tRatings\n"
        for rating in films.Ratings {
            resultLabel.text?.append("Source: \(rating.Source ?? "N/A")\nValue: \(rating.Value ?? "N/A")\n\n")
        }
        
        posterImage.frame = CGRect(x: self.view.center.x / 2 - 20, y: roundesSquare.frame.minY - 300 , width: 200, height: 250)
        
        
        let urlImage = URL(string: "\(films.Poster)")!
        var dataImage = Data()
        do {
            dataImage = try Data (contentsOf: urlImage)
            temp = false
        }catch{
            print("Errore downlaod")
            posterImage.image = UIImage(named: "No_Image_Available_Denny")
            temp = true
        }
        
        if temp == false {
            posterImage.image = UIImage(data: dataImage)
        }
        posterImage.layer.cornerRadius = 15
        posterImage.layer.masksToBounds = true
        
//        saveToCloud(noteText: generatedUserFilm, imageFilm: posterImage)
        saveToCloud(noteText: generatedUserFilm, imageFilm: urlImage, films: films)
        roundesSquare.addSubview(posterImage)
    }
    
    private func errorUpdateLabel() {
        resultLabel.text = "There was an error searching for this film... Check what you wrote.\nMaybe the server is off, try later."
        posterImage.removeFromSuperview()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func saveToCloud(noteText: String, imageFilm: URL, films: Film) {
        let newFilm = CKRecord(recordType: "Book")
        newFilm.setValue(noteText, forKey: "title")
        print(imageFilm)
        let urlString = imageFilm.absoluteString
        newFilm.setValue(urlString, forKey: "imageURL")
        newFilm.setValue(films.Year, forKey: "year")
        newFilm.setValue(films.Plot, forKey: "plot")
        
        print(urlString)
        
        databaseFilm.save(newFilm, completionHandler: {( recordFilm, localError) in
            print(localError)
            guard recordFilm != nil else { print("Something wrong"); return }
            print("Save record with film")
        })
    }
}
