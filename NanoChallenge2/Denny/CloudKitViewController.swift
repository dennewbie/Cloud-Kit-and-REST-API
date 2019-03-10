//
//  CloudKitViewController.swift
//  NanoChallenge2
//
//  Created by Denny Caruso on 10/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit
import CloudKit

class CloudKitViewController: UIViewController {
    
    private var bookTextField = UITextField()
    private var saveButton = UIButton()
    private var readButton = UIButton()
    private var resultLabel = UILabel()
    
    let publicDatabaseCloudKit = CKContainer.default().publicCloudDatabase
    let queryCloudKit = CKQuery(recordType: "Book", predicate: NSPredicate(value: true))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        setupButtons()
        setupQuery()
        setupResultLabel()
    }
    
    
    private func setupTextField() {
        bookTextField.frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 100, height: 30)
        bookTextField.placeholder = "Write here a title book..."
        bookTextField.borderStyle = .roundedRect
        bookTextField.minimumFontSize = 20
        bookTextField.layer.cornerRadius = 15
        bookTextField.returnKeyType = .done
        
        self.view.addSubview(bookTextField)
    }
    
    private func setupButtons() {
        saveButton.frame = CGRect(x: self.view.center.x - 150, y: self.view.frame.minY + 250, width: 300, height: 50)
        saveButton.backgroundColor = .black
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal )
        saveButton.layer.cornerRadius = 15
        saveButton.addTarget(self, action: #selector(saveBook), for: .touchUpInside)
        
        readButton.frame = CGRect(x: self.view.center.x - 150, y: self.view.frame.minY + 450, width: 300, height: 50)
        readButton.backgroundColor = .black
        readButton.setTitle("Read", for: .normal)
        readButton.setTitleColor(.white, for: .normal )
        readButton.layer.cornerRadius = 15
        readButton.addTarget(self, action: #selector(readBook), for: .touchUpInside)
        
        self.view.addSubview(saveButton)
        self.view.addSubview(readButton)
    }
    
    private func setupResultLabel() {
        resultLabel.frame = CGRect(x: 30, y: self.readButton.frame.maxY + 50, width: self.view.frame.width - 50, height: 300)
        resultLabel.backgroundColor = .black
        resultLabel.textColor = .white
        resultLabel.text = "Ciao"
        resultLabel.numberOfLines = 30
        resultLabel.layer.cornerRadius = 15
        resultLabel.layer.masksToBounds = true
        resultLabel.textAlignment = .center
        
        
        
        self.view.addSubview(resultLabel)
    }
    
    @objc private func saveBook() {
        
        if bookTextField.text == "" {
            let errorAlert = UIAlertController(title: "Error", message: "Please insert a valid title.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(errorAlert, animated: true)
        } else {
            let generateUserFilm = bookTextField.text!
            querySave(generateUserFilm: generateUserFilm)
        }
    }
    
    @objc private func readBook() {
        queryRead()
    }
    
    //MARK: CloudKit
    
    private func setupQuery() {
        queryCloudKit.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        print(queryCloudKit)
    }
    
    private func querySave(generateUserFilm: String) {
        let book = CKRecord(recordType: "Book")
        guard let bookTitle = bookTextField.text else { return }
        
        book.setValue(bookTitle, forKey: "title")
        publicDatabaseCloudKit.save(book, completionHandler: { (record, localError) in
            if localError != nil {
                print(localError?.localizedDescription)
            }})
        }
    
    private func queryRead() {
        var retrievedRecords: [CKRecord] = []
        let queryForReading = CKQuery(recordType: "Book", predicate: NSPredicate(value: true))
        queryForReading.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        publicDatabaseCloudKit.perform(queryForReading, inZoneWith: nil, completionHandler: {(records, localError) in
            if (localError != nil) {
                print(localError)
            } else {
                retrievedRecords = records ?? []
                DispatchQueue.main.async {
                    self.resultLabel.text? = "Here you are the result:\n\n"
                    for record in retrievedRecords {
                        let titolo = record.value(forKey: "title") as! String
                        self.resultLabel.text?.append("\(titolo)\n\n")
                    }
                }
            }
        })
    }
    
    private func queryUpdate(passedBook: CKRecord) {
        publicDatabaseCloudKit.save(passedBook) { (record, localError) in
            if localError != nil {
                
            } else {
                
            }
        }
    }
    
    private func queryDelete(passedBook: CKRecord) {
        publicDatabaseCloudKit.delete(withRecordID: passedBook.recordID, completionHandler: { (recordId, localError) in
            if localError != nil {
                
            } else {
                
            }
        })
    }
}
