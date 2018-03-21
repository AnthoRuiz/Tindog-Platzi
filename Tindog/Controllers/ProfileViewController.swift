//
//  ProfileViewController.swift
//  Tindog
//
//  Created by Anthony Ruiz on 3/19/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController {

   @IBOutlet weak var profileImage: UIImageView!
   @IBOutlet weak var profileNameLbl: UILabel!
   @IBOutlet weak var profileEmailLbl: UILabel!
   var currentUserProfile: UserModel?
   
   @IBAction func closeProfileBtn(_ sender: Any) {
      try! Auth.auth().signOut()
      self.navigationController?.popToRootViewController(animated: true)
   }
   override func viewDidLoad() {
        super.viewDidLoad()
      
      
      let imageUrl = URL(string: (self.currentUserProfile?.profileImage)!)
      self.profileImage.sd_setImage(with: imageUrl, completed: nil)
      
      self.profileImage.round()
      self.profileEmailLbl.text = self.currentUserProfile?.email
      self.profileNameLbl.text = self.currentUserProfile?.displayName
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   @IBAction func importUserAction(_ sender: Any) {
      let users  = [["email": "bruno@asd.com", "password": "123456", "displayName": "Bruno", "photoURL":"https://i.imgur.com/YYqOgZB.jpg"],
                    ["email": "bublie@asd.com", "password": "123456", "displayName": "Bublie", "photoURL":"https://i.imgur.com/rmBXzbv.jpg"],
                    ["email": "buddy@asd.com", "password": "123456", "displayName": "Buddy", "photoURL":"https://i.imgur.com/piEDB2T.jpg"],
                    ["email": "boss@asd.com", "password": "123456", "displayName": "Boss", "photoURL":"https://i.imgur.com/gCclkXK.jpg"],
                    ["email": "chipotle@asd.com", "password": "123456", "displayName": "Chipotle", "photoURL":"https://i.imgur.com/ocNYvgJ.jpg"]]
      
      for userDemo in users{
         Auth.auth().createUser(withEmail: userDemo["email"]!, password: userDemo["password"]!, completion: { (user, error) in
            if let user = user{
               let userData = ["provider": user.providerID, "email": user.email!, "profileImage": userDemo["photoURL"]!, "displayName": userDemo["displayName"]!, "userIsOnMatch": false] as [String: Any]
               DataBaseService.instance.createFirebaseDBUser(uid: user.uid, userData: userData)
            }
            
         })
      }
   }
   

}
