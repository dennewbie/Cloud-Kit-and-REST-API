//
//  CloudKitTableViewCell.swift
//  NanoChallenge2
//
//  Created by Denny Caruso on 11/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit

class CloudKitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgFilm: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.layer.cornerRadius = 15
        super.layer.masksToBounds = true
    }

}
