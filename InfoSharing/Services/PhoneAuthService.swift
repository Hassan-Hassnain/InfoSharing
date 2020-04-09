//
//  PhoneAuthService.swift
//  InfoSharing
//
//  Created by Usama Sadiq on 4/10/20.
//  Copyright © 2020 Usama Sadiq. All rights reserved.
//

import Foundation
import Firebase

class PhoneAuthService {
    
    static let instance = PhoneAuthService()
    
    func loginWthThisNumber(_ phoneNumber: String, registationResult: @escaping (_ error: Error?)->()) {
        
        guard !phoneNumber.isEmpty else {print("Phone number is empty"); return}
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error == nil {
                guard let verificationID = verificationID else {return}
                
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                print("VerificationID", verificationID)
                registationResult( nil)
                
            } else {
                print("Unable to get secret verification code from firebase", error?.localizedDescription ?? "")
                registationResult( error)
            }
        }
    }
    
    func verigyNumber(verificationCode otpCode: String, verificationResult: @escaping (_ error: Error?)->()) {
        
        guard !otpCode.isEmpty else { print("verification code is empty"); return}
        
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {return}
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpCode)
        
        Auth.auth().signIn(with: credential) { (authDataResult, error) in
            if error == nil {
                print("Login successful with phone number")
              verificationResult(nil)
            } else {
                print("Failed ", error?.localizedDescription ?? "")
                verificationResult(error)
            }
        }
    }
    
    
    
}

