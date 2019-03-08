//
//  FilmViewController.swift
//  NanoChallenge2
//
//  Created by Denny Caruso on 08/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit

struct Film: Decodable {
//    let id: Int?
//    let name: String?
//    let link: String?
//    let imageUrl: String?
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
}

class FilmViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupTitleLabel()
        setupResultLabel()
        setupTextField()
        setupButton()
    }
    
    private func setupScrollView() {
        self.view.addSubview(scrollViewFilm)
    
        scrollViewFilm.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        scrollViewFilm.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0).isActive = true
        scrollViewFilm.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        scrollViewFilm.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
        scrollViewFilm.contentSize = CGSize(width: (self.view.frame.width - 20), height: (self.view.frame.height) + 300)
    }
    
    private func setupTitleLabel() {
        titleLabel.frame = CGRect(x: 20, y: 100, width: 100, height: 50)
        titleLabel.text = "Title"
        titleLabel.font = titleLabel.font.withSize(20)
        titleLabel.layer.cornerRadius = 15
        titleLabel.layer.masksToBounds = true
        titleLabel.textColor = .black
        
        scrollViewFilm.addSubview(titleLabel)
    }
    
    private func setupTextField() {
        searchFilmTextField.frame = CGRect(x: 20, y: 150, width: self.view.frame.width - 100, height: 30)
        searchFilmTextField.placeholder = "Write here a title film..."
        searchFilmTextField.borderStyle = .roundedRect
        searchFilmTextField.minimumFontSize = 20
        searchFilmTextField.layer.cornerRadius = 15
        searchFilmTextField.returnKeyType = .done
        
        scrollViewFilm.addSubview(searchFilmTextField)
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
        roundesSquare.frame = CGRect(x: 20, y: (self.view.frame.height / 2) - 100, width: self.view.frame.width - 50, height: (self.view.frame.height) - 100)
        roundesSquare.backgroundColor = UIColor.darkGray
        roundesSquare.layer.cornerRadius = 15
        
        resultLabel.frame = CGRect(x: 10, y: 10, width: roundesSquare.frame.width - 5, height: roundesSquare.frame.height)
        resultLabel.text = "Here you will see the result..."
        resultLabel.font = titleLabel.font.withSize(20)
        resultLabel.layer.cornerRadius = 15
        resultLabel.layer.masksToBounds = true
        resultLabel.numberOfLines = 30
        resultLabel.textColor = .white
        
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

            let generateUserFilm = searchFilmTextField.text
            let filteredFilm = generateUserFilm!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            jsonURL.append(filteredFilm)
            jsonURL.append("&apikey=5f784705")
        }
        
        print(jsonURL)
        
        guard let myURL = URL(string: jsonURL) else { print("Error URL"); return }
        
        URLSession.shared.dataTask(with: myURL) { (data, response, err) in
            guard let data = data else { return }
            do {
                let films = try JSONDecoder().decode(Film.self, from: data)
//                for film in films {
////                    print(film)
//                    print(film.title)
//                }
                print(films)
                DispatchQueue.main.async {
                    self.updateResultLabel(films: films)
                }
            } catch let jsonError {
                print("Error serializin json", jsonError)
            }
            }.resume()
    }
    
    private func updateResultLabel(films: Film) {
        resultLabel.text = "Result:\n\nTitle: \(films.Title)\nYear: \(films.Year)\nRated: \(films.Rated)\nReleased: \(films.Released)\n\nRuntime: \(films.Runtime)\nGenre: \(films.Genre)\nDirector: \(films.Director)\nWriter: \(films.Writer)\nActors: \(films.Actors)\n\nPlot: \(films.Plot)\nLanguage: \(films.Language)\nAwards: \(films.Awards)\nPoster: \(films.Poster)"
    }
}
