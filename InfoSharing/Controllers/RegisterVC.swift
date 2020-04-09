//
//  RegisterVC.swift
//  InfoSharing
//
//  Created by Usama Sadiq on 4/8/20.
//  Copyright © 2020 Usama Sadiq. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if let name = nameTF.text ,let email = emailTF.text, let password = passwordTF.text {
            AuthService.instance.registerUser(withEmail: email, andPassword: password) { (user, error) in
                if error == nil {
                    if let user = user {
                        let userData = [kUserData.PROVIDER_ID : user.providerID, kUserData.USER_NAME : name ,kUserData.UESR_EMAIL : user.email]
                        DataService.instance.createDBUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
                        print("Registration successful with \(user.uid)")
                    }
                } else {
                    print("User registation failed")
                }
            }
        }
    }
    
}
