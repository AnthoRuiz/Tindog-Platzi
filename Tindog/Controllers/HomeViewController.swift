//
//  HomeViewController.swift
//  Tindog
//
//  Created by Anthony Ruiz on 3/16/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit
import RevealingSplashView
import Firebase

class NavigationImageView : UIImageView{
   override func sizeThatFits(_ size: CGSize) -> CGSize {
      return CGSize(width: 76, height: 39)
   }
}

class HomeViewController: UIViewController {

   @IBOutlet weak var cardProfileName: UILabel!
   @IBOutlet weak var cardProfileImage: UIImageView!
   @IBOutlet weak var homeWrapper: UIStackView!
   @IBOutlet weak var cardView: UIView!
   @IBOutlet weak var likeImage: UIImageView!
   @IBOutlet weak var nopeImage: UIImageView!
   var currentUserProfile: UserModel?
   var currentMatch: MatchModel?
   var users = [UserModel]()
   var seconUserUID : String?
   let leftBtn = UIButton(type: .custom)
   let rightBtn = UIButton(type: .custom)
   
   //splash screen
   let revealingSplashScreen = RevealingSplashView(iconImage: UIImage(named:"splash_icon")!, iconInitialSize: CGSize(width:80, height:80), backgroundColor: UIColor.white)
   
   override func viewDidLoad() {
        super.viewDidLoad()
      
      //add splash screen
      self.view.addSubview(self.revealingSplashScreen)
      
      self.revealingSplashScreen.animationType = SplashAnimationType.popAndZoomOut
      self.revealingSplashScreen.startAnimation()
      
      //add image navigation view, (top)
      let tittleView = NavigationImageView()
      tittleView.image = UIImage(named: "Actions")
      self.navigationItem.titleView = tittleView

      //Reconize gestures in the cardView
      let homeGR = UIPanGestureRecognizer(target: self, action: #selector(cardDragged(gestureRecognizer:)))
      self.cardView.addGestureRecognizer(homeGR)
      
      
      //add left button for open login
      self.leftBtn.imageView?.contentMode = .scaleAspectFit
      let leftBarButton = UIBarButtonItem(customView: leftBtn)
      self.navigationItem.leftBarButtonItem = leftBarButton
      
      //check if the user is log in
      Auth.auth().addStateDidChangeListener { (auth, user) in
         if let user = user {
            print("usuario inicio correctamente")
         }else{
            print("logout")
         }
         
         //call to userprofile modal
         DataBaseService.instance.observeUserProfile { (userDict) in
            self.currentUserProfile = userDict
            UpdateDBService.instance.observeMatch(handler: { (matchDict) in
               if let match = matchDict{
                  if let user = self.currentUserProfile{
                     if user.userIsOnMatch == false{
                        print("tienes un match")
                        self.currentMatch = match
                        self.changeRightBtn(active: true)
                     }
                  }
               }else{
                  self.changeRightBtn(active: false)
               }
            })
         }
         self.getUsers()
      }
     
      self.rightBtn.imageView?.contentMode = .scaleAspectFit
      let rigthtBarButton = UIBarButtonItem(customView: rightBtn)
      self.navigationItem.rightBarButtonItem = rigthtBarButton
      
      
        // Do any additional setup after loading the view.
    }
   
   func changeRightBtn(active: Bool){
      if active{
         self.rightBtn.setImage(UIImage(named:"match_active"), for: .normal)
         self.rightBtn.addTarget(self, action: #selector(goToMatch(sender:)), for: .touchUpInside)
      }else {
         self.rightBtn.removeTarget(nil, action: nil, for: .allEvents)
         self.rightBtn.setImage(UIImage(named:"match_inactive"), for: .normal)
         
      }
   }
   
   //go to login at click
   @objc func goToLogin(sender: UIButton){
      let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
      let loginViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC")
      present(loginViewController, animated: true, completion: nil)
   }
   
   //go to Profile at click
   @objc func goToProfile(sender: UIButton){
      let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
      let profileViewController = storyBoard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
      profileViewController.currentUserProfile = self.currentUserProfile
      self.navigationController?.pushViewController(profileViewController, animated: true)
   }
   
   //go to match at click
   @objc func goToMatch(sender: UIButton){
      let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
      let matchViewController = storyBoard.instantiateViewController(withIdentifier: "matchVC") as! MatchViewController
      matchViewController.currentUserProfile = self.currentUserProfile
      matchViewController.currentMatch = self.currentMatch
      //matchViewController.lastImage = self.view.screenshot()
      present(matchViewController, animated: true, completion: nil)
   }
   
   func getUsers(){
      DataBaseService.instance.User_Ref.observeSingleEvent(of: .value) { (snapshot) in
         let userSnapshot = snapshot.children.flatMap{ UserModel(snapshot: $0 as! DataSnapshot)}
         for user in userSnapshot{
            //print("user: \(user.email)")
            if self.currentUserProfile?.uid != user.uid{
               self.users.append(user)
            }
         }
         if self.users.count > 0{
            self.updateImage(uid: (self.users.first?.uid)!)
            
         }
      }

   }
   
   func updateImage(uid: String){
      DataBaseService.instance.User_Ref.child(uid).observeSingleEvent(of: .value) { (snapshot) in
         if let userProfile = UserModel(snapshot: snapshot){
            self.seconUserUID = userProfile.uid
            self.cardProfileImage.sd_setImage(with: URL(string: userProfile.profileImage), completed: nil)
            self.cardProfileName.text = userProfile.displayName
         }
      }
   }
   
   //funtion recognizer drag
   @objc func cardDragged(gestureRecognizer : UIPanGestureRecognizer){
      let cardPoint = gestureRecognizer.translation(in: view)
      self.cardView.center = CGPoint(x: self.view.bounds.width / 2 + cardPoint.x , y: self.view.bounds.height / 2 + cardPoint.y)
      
      //animation rotate
      let xFromCenter = self.view.bounds.width / 2 - self.cardView.center.x
      var rotate = CGAffineTransform(rotationAngle: xFromCenter / 200)
      let scale = min(100 / abs(xFromCenter), 1)
      var finalTransform = rotate.scaledBy(x: scale, y: scale)
      
      self.cardView.transform = finalTransform
      
      //logic for like or dislake
      if self.cardView.center.x < (self.view.bounds.width / 2 - 100){
         self.nopeImage.alpha = min(abs(xFromCenter) / 100, 1)
      }
      if self.cardView.center.x > (self.view.bounds.width / 2 + 100){
         self.likeImage.alpha = min(abs(xFromCenter) / 100, 1)
      }
      
      if gestureRecognizer.state == .ended{
         if self.cardView.center.x < (self.view.bounds.width / 2 - 100){
            print("dislike")
         }
         if self.cardView.center.x > (self.view.bounds.width / 2 + 100){
            print("like")
            //match
            if let uid2 = self.seconUserUID{
               DataBaseService.instance.createFirebaseDBMatch(uid: self.currentUserProfile!.uid, uid2: uid2)
            }
            
         }
         
         //update image
         if self.users.count > 0{
            self.updateImage(uid: self.users[self.random(0..<self.users.count)].uid)
         }
         
         
         //restar card view
         rotate = CGAffineTransform(rotationAngle: 0)
         finalTransform  = rotate.scaledBy(x: 1, y: 1)
         self.cardView.transform = finalTransform
         self.cardView.center = CGPoint(x: self.homeWrapper.bounds.width / 2 , y: (self.homeWrapper.bounds.height / 2 - 30) )
         self.likeImage.alpha = 0
         self.nopeImage.alpha = 0
      }
   }
   
   override func viewDidAppear(_ animated: Bool) {
      if Auth.auth().currentUser != nil {
         self.leftBtn.setImage(UIImage(named:"login_active"), for: .normal)
         self.leftBtn.removeTarget(nil, action: nil, for: .allEvents)
         self.leftBtn.addTarget(self, action: #selector(goToProfile(sender:)), for: .touchUpInside)
      }else{
         self.leftBtn.setImage(UIImage(named:"login"), for: .normal)
         self.leftBtn.removeTarget(nil, action: nil, for: .allEvents)
         self.leftBtn.addTarget(self, action: #selector(goToLogin(sender:)), for: .touchUpInside)
      }
   }

   //random for img
   func random(_ range: Range<Int>) -> Int {
      return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
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
