//
//  ArticleCell.swift
//  NanoChallenge2
//
//  Created by Vincenzo on 10/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit

class ArticleCell: UICollectionViewCell {

    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    var articleLink : URL?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.linkButton.layer.cornerRadius = 15
        self.previewImage.layer.cornerRadius = 15
    }

    @IBAction func goToLink(_ sender: Any) {
        UIApplication.shared.open(articleLink!)
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
