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
    var articleLink : URL?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func goToLink(_ sender: Any) {
        UIApplication.shared.open(articleLink!)
    }
}
