//
//  LoginWithPhooneVC.swift
//  InfoSharing
//
//  Created by Usama Sadiq on 4/9/20.
//  Copyright © 2020 Usama Sadiq. All rights reserved.
//

import UIKit
//import Firebase

class LoginWithPhooneVC: UIViewController {
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var verificationCodeTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.text = ""
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTF.text else {return}
        PhoneAuthService.instance.loginWthThisNumber(phoneNumber) { (error) in
            if error == nil {
                print("Verify your number")
                self.errorLabel.text = "Enter verification code"
            } else {
                print(error?.localizedDescription ?? "")
                self.errorLabel.text = error?.localizedDescription ?? ""
            }
        }
    }
    
    @IBAction func verifyButtonTapped(_ sender: UIButton) {
        
        guard let otpCode = verificationCodeTF.text else {return}
        
        PhoneAuthService.instance.verigyNumber(verificationCode: otpCode) { (error) in
            if error == nil {
                print("Login successful with phone number")
                guard let vc = self.storyboard?.instantiateViewController(identifier: "MainVC") else {return}
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.errorLabel.text = error?.localizedDescription ?? ""
                print("Failed ", error?.localizedDescription ?? "")
            }
        }
        
        //         guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {return}
        //        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpCode)
        //
        //        Auth.auth().signIn(with: credential) { (authDataResult, error) in
        //            if error == nil {
        //                print("Login successful with phone number")
        //                guard let vc = self.storyboard?.instantiateViewController(identifier: "MainVC") else {return}
        //                self.navigationController?.pushViewController(vc, animated: true)
        //
        //
        //            } else {
        //                self.errorLabel.text = error?.localizedDescription ?? ""
        //                print("Failed ", error?.localizedDescription ?? "")
        //            }
        //        }
    }
    
    
}
