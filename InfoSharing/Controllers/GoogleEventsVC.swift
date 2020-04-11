//
//  GoogleEventsVC.swift
//  InfoSharing
//
//  Created by Usama Sadiq on 4/11/20.
//  Copyright © 2020 Usama Sadiq. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher
import UIAlertDateTimePicker

class GoogleEventsVC: GoogleCalendarEventService {
    
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var userMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func signInWithGoogleButton(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func startDateButton(_ sender: Any) {
        isStartDate = true
        showDatePicker()
    }
    
    @IBAction func endDateButton(_ sender: Any) {
        
       showDatePicker()
    }
    @IBAction func addEventButton(_ sender: Any) {
        
//        addEventoToGoogleCalendar(summary: titleTF.text!, description: descriptionTF.text!, startTime: myStartDate, endTime:myEndDate)
        
//        fetchEvents()
        getEvent(startDate: startDate!, endDate: endDate!)
        
        userMsg.text = outPut
        print(outPut)
    }
    
}
