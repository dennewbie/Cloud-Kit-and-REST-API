//
//  ArticleCell.swift
//  NanoChallenge2
//dc
//  Created by Vincenzo on 10/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit
import CloudKit

class ArticleCell: UICollectionViewCell {

    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    var articleLink : URL?
    var imageLink : String?
    //Data will be saved in a private database on icloud
    //let database = CKContainer.default().privateCloudDatabase
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.linkButton.layer.cornerRadius = 15
        self.previewImage.layer.cornerRadius = 15
        //self.saveButton.layer.cornerRadius = 15
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        
        // add it to the image view;
        previewImage.addGestureRecognizer(tapGesture)
    }

    @IBAction func goToLink(_ sender: Any) {
        UIApplication.shared.open(articleLink!)
    }
    /*@IBAction func saveButtonPressed(_ sender: Any) {
        //Steps for save a new link
        //Nome della tabella
        let linkToSave = CKRecord(recordType: "LinkToArticle")
        //Nome del campo
        linkToSave["Link"] = self.articleLink!.absoluteString
        linkToSave["Image"] = self.imageLink!
        database.save(linkToSave) { (record, error) in
            if ( error != nil) {
                guard record != nil else { return }
                print("Saved the record: ")
                print(record)
            }
            else {
                print("ERROR IN SAVING: ")
                print(error)
            }
        }
            
        
    }
    */
   @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if let imageView = gesture.view as? UIImageView {
            UIApplication.shared.open(self.articleLink!)
            //Here you can initiate your new ViewController
            
        }
    }

}


extension UIImageView {
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }

    
    
}
