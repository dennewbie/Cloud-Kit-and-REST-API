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

    let databaseFilm = CKContainer.default().publicCloudDatabase
    
    var filmSearched = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        let cellFilm = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as! FilmTableViewCell
        
        let note = filmSearched[indexPath.row].value(forKey: "content") as! String
        cellFilm.lblTitle.text = note
        return cellFilm
    }
}
