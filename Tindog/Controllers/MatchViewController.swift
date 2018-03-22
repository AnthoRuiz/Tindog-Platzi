//
//  MatchViewController.swift
//  Tindog
//
//  Created by Anthony Ruiz on 3/21/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit
import SDWebImage

class MatchViewController: UIViewController {

   @IBOutlet weak var doneBtn: UIButton!
   @IBOutlet weak var secondUserMatchImage: UIImageView!
   @IBOutlet weak var firstUserMatchImage: UIImageView!
   @IBOutlet weak var copyMatchLbl: UILabel!
   var currentUserProfile: UserModel?
   var currentMatch: MatchModel?
   
   
   @IBAction func doneBtnAction(_ sender: Any) {
      
   }
   
   
   override func viewDidLoad() {
        super.viewDidLoad()
      if let match = self.currentMatch{
         print("------match:---------- \(match)")
         if let profile = self.currentUserProfile{
            self.secondUserMatchImage.sd_setImage(with: URL(string:profile.profileImage), completed: nil)
            self.secondUserMatchImage.round()
         }
      }

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
