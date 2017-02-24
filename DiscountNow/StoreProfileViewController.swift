//
//  StoreProfileViewController.swift
//  DiscountNow
//
//  Created by Ethan's Badass Penguin on 2/5/17.
//  Copyright © 2017 Ethan's Badass Penguin. All rights reserved.
//

import UIKit

class StoreProfileViewController: UITableViewController {

    var partner: Partner? {
        didSet{
            navigationItem.title = partner?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

         
    
    
    
    }

 

}
