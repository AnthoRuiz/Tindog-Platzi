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
      self.dismiss(animated: true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
