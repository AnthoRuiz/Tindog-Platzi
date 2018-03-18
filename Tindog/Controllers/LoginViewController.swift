//
//  LoginViewController.swift
//  Tindog
//
//  Created by Anthony Ruiz on 3/17/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

   //close modal del login
   @IBAction func closeBtn(_ sender: Any) {
      dismiss(animated: true, completion: nil)
      
   }
   override func viewDidLoad() {
        super.viewDidLoad()
      
      //move view when keyboard is open
      self.view.bindKeyboard()
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
      self.view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
   
   //close the keyboard
   @objc func handleTap(sender: UITapGestureRecognizer){
      self.view.endEditing(true)
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
