//
//  LoginViewController.swift
//  Tindog
//
//  Created by Anthony Ruiz on 3/17/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
   
   
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var loginBtn: UIButton!
   @IBOutlet weak var loginCopyLbl: UILabel!
   @IBOutlet weak var subLoginBtn: UIButton!
   
   var registerMode = true
   
   //func for sublogin btn
   @IBAction func subLoginActionBtn(_ sender: Any) {
      
      if self.registerMode{
         self.loginBtn.setTitle("Login", for: .normal)
         self.loginCopyLbl.text = "Eres Nuevo?"
         self.subLoginBtn.setTitle("Registrate", for: .normal)
         self.registerMode = false
      }else{
         self.loginBtn.setTitle("Crear Cuenta", for: .normal)
         self.loginCopyLbl.text = "Ya tienes Cuenta?"
         self.subLoginBtn.setTitle("Login", for: .normal)
         self.registerMode = true
      }
      
   }
   
   func showAlert(title: String, message: String){
      
      let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alertView, animated: true, completion: nil)
   }
   
   //func for login/register btn
   @IBAction func loginActionBtn(_ sender: Any) {
      
      if self.emailTextField.text == "" || self.passwordTextField.text == ""{
         
         self.showAlert(title: "Error", message: "Algunos de los campos esta Vacio")
         
      }else{
         
         if let email = self.emailTextField.text{
            if let password = self.passwordTextField.text{
               if registerMode{
                  Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                     if error != nil{
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                     }else{
                        print("cuenta Creada")
                        if let user = user {
                           let userData = ["provider": user.providerID, "email": user.email!, "profileImage": "https://i.imgur.com/j877JeB.jpg", "displayName": "Jakaboy"] as [String: Any]
                           
                           DataBaseService.instance.createFirebaseDBUser(uid: user.uid, userData: userData)
                        }
                        
                        
                     }
                  })
               }else{
                  Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                     if error != nil{
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                     }else{
                        print("login Correcto")
                        self.dismiss(animated: true, completion: nil)
                     }
                  })
               }
            }
         }
         
      }

   }
   
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
