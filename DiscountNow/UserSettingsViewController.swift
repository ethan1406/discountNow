//
//  UserSettingsViewController.swift
//  DiscountNow
//
//  Created by Ethan's Badass Penguin on 1/8/17.
//  Copyright © 2017 Ethan's Badass Penguin. All rights reserved.
//

import UIKit
import Firebase

class UserSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
            }
            
        }, withCancel: nil)
        
    }


}
