//
//  ViewController.swift
//  InfoSharing
//
//  Created by Usama Sadiq on 4/8/20.
//  Copyright © 2020 Usama Sadiq. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if emailTF != nil, passwordTF != nil {
            AuthService.instance.loginUser(withEmail: emailTF.text!, andPassword: passwordTF.text!) { (success, error) in
                if success {
                    let vc = self.storyboard?.instantiateViewController(identifier: "MainVC") as! MainVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    debugPrint(error!)
                }
            }
        }
        
    }
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "RegisterVC") as! RegisterVC
               navigationController?.pushViewController(vc, animated: true)
    }
    

}

