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
        if emailTF != nil, passwordTF != nil {
            AuthService.instance.createUser(withEmail: emailTF.text!, andPassword: passwordTF.text!) { (user) in
                guard let user = user else {return}
                let dict = [
                    UserData.USER_NAME: self.nameTF.text!,
                    UserData.UESR_EMAIL: self.emailTF.text!,
                ]
                
                DataService.instance.updateDBUser(uid: user.uid, userData: dict) {(success) in
                    if success {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                            self.statusLabel.text = "Your are registerd successfully!"
                            self.navigationController?.popViewController(animated: true)
                        })
                    } else {
                        print("Database update failed")
                    }
                }
            }
        }
    }
    
    
}

