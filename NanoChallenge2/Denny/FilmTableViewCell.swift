//
//  FilmTableViewCell.swift
//  NanoChallenge2
//
//  Created by Denny Caruso on 11/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit

class FilmTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
