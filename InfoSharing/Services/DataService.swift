//
//  DataService.swift
//  Foody_Bite
//
//  Created by Usama Sadiq on 3/15/20.
//  Copyright © 2020 Usama Sadiq. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage


let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    
    
    func updateDBUser(uid: String, userData: Dictionary<String, Any>, onSuccess: @escaping (_ success: Bool)->()) {
        REF_USERS.child(uid).updateChildValues(userData, withCompletionBlock: {
            (error, ref) in
            if error == nil {
                onSuccess(true)
            } else {
                onSuccess(false)
            }
        })
    }
    
    func getUserData(forUID uid: String, handler: @escaping (_ user: User) -> ()){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let FirebaseUser = userSnapShot .children.allObjects as? [DataSnapshot] else {return}
            
            for FirUser in FirebaseUser {
                if FirUser.key == uid {
                    let name = FirUser.childSnapshot(forPath: UserData.USER_NAME).value as! String
                    let email = FirUser.childSnapshot(forPath: UserData.UESR_EMAIL).value as! String
                    
                    let user = User(uid: FirUser.key, name: name, email: email)
                    handler(user)
                }
            }
        }
    }
    
    
}
