//
//  CloudKitTableViewController.swift
//  NanoChallenge2
//
//  Created by Denny Caruso on 11/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit
import CloudKit

class CloudKitTableViewController: UIViewController {
    
    @IBOutlet weak var cloudKitTableView: UITableView!
    
    let databaseFilm = CKContainer.default().publicCloudDatabase
    var filmSearched = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        deleteAllRecords()
        queryRead()
        setupRefresh()
        cloudKitTableView.delegate = self
        cloudKitTableView.dataSource = self
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func reloadData(_ sender: Any?) {
        filmSearched.removeAll()
        cloudKitTableView.reloadData()
        queryRead()
    }
    
    
    
    @objc private func queryRead() {
        let query = CKQuery(recordType: "Book", predicate: NSPredicate(value: true))
        databaseFilm.perform(query, inZoneWith: nil, completionHandler: {( records, _ ) in
            guard let records = records else { print("Error"); return }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate! })
            for item in sortedRecords {
                self.filmSearched.append(item)
//                print(item)
            }
            DispatchQueue.main.async {
                self.cloudKitTableView.reloadData()
            }
        })
    }
    
    private func queryDelete(passedFilm: CKRecord) {
        databaseFilm.delete(withRecordID: passedFilm.recordID, completionHandler: { (recordId, localError) in
            if localError != nil {
                print(localError)
            } else {
                print("Record Deleted")
            }
        })
        
    }
    
    private func deleteAllRecords() {
        let query = CKQuery(recordType: "Book", predicate: NSPredicate(value: true))
        databaseFilm.perform(query, inZoneWith: nil) { (records, error) in
            
            if error == nil {
                for record in records! {
                    self.databaseFilm.delete(withRecordID: record.recordID, completionHandler: { (recordId, error) in
                        
                        if error == nil {
                            print("RECORD DELETED  ")
                        }
                    })
                }
            }
        }
    }
    
    private func setupRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadList), for: .valueChanged)
        self.cloudKitTableView.refreshControl = refreshControl
    }
    
    @objc func loadList(){
        print("Mi ha osservato")
        DispatchQueue.main.async {
            self.filmSearched.removeAll()
            sleep(1)
            self.queryRead()
            self.cloudKitTableView.reloadData()
            DispatchQueue.main.async {
                self.cloudKitTableView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension CloudKitTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmSearched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellFilm = tableView.dequeueReusableCell(withIdentifier: "cellFilm", for: indexPath) as! CloudKitTableViewCell
        
        cellFilm.labelTitle.text = filmSearched[indexPath.row].value(forKey: "title") as! String
        cellFilm.labelTitle.text?.append("\n\(filmSearched[indexPath.row].value(forKey: "year") as! String)\n\n\(filmSearched[indexPath.row].value(forKey: "plot") as! String)")
        
        
        guard let stringURL = filmSearched[indexPath.row].value(forKey: "imageURL") as? String else {
            cellFilm.imgFilm.image = UIImage(named: "No_Image_Available_Denny")
            return cellFilm
        }
        
        guard let urlImage = URL(string: "\(stringURL)") else {
            cellFilm.imgFilm.image = UIImage(named: "No_Image_Available_Denny")
            return cellFilm
        }
        
        var dataImage = Data()
        do {
            dataImage = try Data (contentsOf: urlImage)
        }catch{
            print("Errore download Image")
            cellFilm.imgFilm.image = UIImage(named: "No_Image_Available_Denny")
            return cellFilm
        }
        cellFilm.imgFilm.image = UIImage(data: dataImage)
        
        return cellFilm
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped \(indexPath.row).")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            databaseFilm.delete(withRecordID: filmSearched[indexPath.row].recordID, completionHandler: {( record, error ) in
                if error == nil {
                    print("Record Deleted")
                } else {
                    print(error)
                }
            })
            filmSearched.removeAll()
            cloudKitTableView.reloadData()
            sleep(1)
            queryRead()
            cloudKitTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = tableView.cellForRow(at: indexPath) as? CloudKitTableViewCell {
                cell.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = tableView.cellForRow(at: indexPath) as? CloudKitTableViewCell {
                cell.transform = .init(scaleX: 0.95, y: 0.90)
            }
        }
    }
}
