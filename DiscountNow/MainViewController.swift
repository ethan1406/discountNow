//
//  ViewController.swift
//  DiscountNow
//
//  Created by Ethan's Badass Penguin on 12/29/16.
//  Copyright © 2016 Ethan's Badass Penguin. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UITableViewController {

      let cellId = "cellId"
      var partners = [Partner]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
      
//        let image = UIImage(named: "56-512")
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleSettings))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)

        checkIfUserIsLoggedin()
    
        fetchPartners()
        
    }
    
    
    
    func fetchPartners(){
        
        FIRDatabase.database().reference().child("partners").observe(.childAdded, with: { (snapshot) in
            
            let dicitionary = snapshot.value as? [String : AnyObject] ?? [:]
            let discountItems = dicitionary["DiscountItems"] as? [String : Int] ?? [:]
            
            let partner = Partner()
            partner.name = snapshot.key
            partner.profileImageUrl = dicitionary["ProfileImageUrl"] as? String
            partner.discountItems = [:]
            
            
            for (item, discount) in discountItems {
                
                partner.discountItems?[item] = discount
                
            }
            print(partner.discountItems)
            print("hehehe!!!!!!!!!!!!!!!!!!!")
            print(partner.profileImageUrl)
            
            self.partners.append(partner)
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
            
            
        }, withCancel: nil)
    }

  
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return partners.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let partner = partners[indexPath.row]
        
        cell.textLabel?.text = partner.name
        var temp = ""
        
        for(item, discount) in partner.discountItems!{
            temp += item
            temp += " : "
            temp +=  String(discount)
            temp += "% off"
            
        }
        
        cell.detailTextLabel?.text = temp
        if let profileImageUrl = partner.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }

        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let partner = partners[indexPath.row]
        showStoreProfile(partner: partner)
        
    }
    
    
    func showStoreProfile(partner: Partner){
        let storeProfileController = StoreProfileViewController()
        storeProfileController.partner = partner
        navigationController?.pushViewController(storeProfileController, animated: true)
        
    }

    

    func checkIfUserIsLoggedin (){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    func handleLogout(){
        let loginViewController = LoginViewController()

        present(loginViewController, animated: true, completion: nil)
    }

      @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print (logoutError)
        }
        
    }
  

}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
       
        
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive
            = true

        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



