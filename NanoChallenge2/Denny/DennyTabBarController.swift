//
//  DennyTabBarController.swift
//  Alamofire
//
//  Created by Denny Caruso on 12/03/2019.
//

import UIKit

class DennyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "AIUTO"

    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.title =
        self.tabBarController?.tabBar.items?[0].title = NSLocalizedString("BotonMapas", comment: "comment")
        self.tabBarController?.tabBar.items?[1].title = NSLocalizedString("BotonRA", comment: "comment")
        self.navigationItem.title = "AIUTO"
    }
}
