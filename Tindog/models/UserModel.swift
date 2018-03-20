//
//  UserModel.swift
//  Tindog
//
//  Created by Anthony Ruiz on 3/19/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import Foundation

import Firebase

struct UserModel {
   let uid: String
   let email: String
   let provider: String
   let profileImage: String
   let displayName: String
   
   init?(snapshot: DataSnapshot){
      let uid = snapshot.key
      //print(snapshot.value)
      guard let dic = snapshot.value as? [String:Any],
         let email = dic["email"] as? String,
         let provider = dic["provider"] as? String,
         let profileImage = dic["profileImage"] as? String,
         let displayName = dic["displayName"] as? String
         else {
            return nil
         }
      
      self.uid = uid
      self.email = email
      self.provider = provider
      self.profileImage = profileImage
      self.displayName = displayName
   }
}
