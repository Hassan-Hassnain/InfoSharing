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

class GoogleEventsVC: UIViewController {
    
    private let scopes = [kGTLRAuthScopeCalendar]
    private let service = GTLRCalendarService()
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var userMsg: UILabel!
    
    private var myStartDate = ""
    private var myEndDate = ""
    var isStartDate = false
    
    var datePicker: UIAlertDateTimePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //GIDSignIn.sharedInstance().clientID = CLIENT_ID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance()?.presentingViewController = self
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
        
        addEventoToGoogleCalendar(summary: titleTF.text!, description: descriptionTF.text!, startTime: myStartDate, endTime:myEndDate)
    }
    
    func addEventoToGoogleCalendar(summary : String, description :String, startTime : String, endTime : String) {
        let calendarEvent = GTLRCalendar_Event()
        
        calendarEvent.summary = "\(summary)"
        calendarEvent.descriptionProperty = "\(description)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let startDate = dateFormatter.date(from: startTime)
        let endDate = dateFormatter.date(from: endTime)
        
        guard let toBuildDateStart = startDate else {
            print("Error getting start date")
            return
        }
        guard let toBuildDateEnd = endDate else {
            print("Error getting end date")
            return
        }
        calendarEvent.start = buildDate(date: toBuildDateStart)
        calendarEvent.end = buildDate(date: toBuildDateEnd)
        
        let insertQuery = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: "primary")
        
        service.executeQuery(insertQuery) { (ticket, object, error) in
            if error == nil {
                print("Event inserted")
            } else {
                print(error)
            }
        }
    }
    
    
    // Helper to build date
    func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
        let datetime = GTLRDateTime(date: date)
        let dateObject = GTLRCalendar_EventDateTime()
        dateObject.dateTime = datetime
        return dateObject
    }
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

extension GoogleEventsVC:GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.service.authorizer = user.authentication.fetcherAuthorizer()
    }
    
    //MARK:Google SignIn Delegate
    
//    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//        // myActivityIndicator.stopAnimating()
//        print("First Function Called")
//    }
//    // Present a view that prompts the user to sign in with Google
//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//        print("Second Function Called")
//        self.present(viewController, animated: true, completion: nil)
//
//    }
//
//    // Dismiss the "Sign in with Google" view
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//        print("Third Function Called")
//        self.dismiss(animated: true, completion: nil)
//    }
//    ////Google_signIn
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) {
//        if let error = error {
//            showAlert(title: "Authentication Error", message: error.localizedDescription)
//            self.service.authorizer = nil
//        } else {
//            self.service.authorizer = user.authentication.fetcherAuthorizer()
//    //        addEventoToGoogleCalendar(summary: "summary9", description: "description", startTime: "12/04/2020 09:00", endTime: "12/04/2020 10:00")
//        }
//    }
}



extension GoogleEventsVC: UIAlertDateTimePickerDelegate {
    func positiveButtonClicked(withDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
               if isStartDate {
                myStartDate = dateFormatter.string(from: date)
                   isStartDate = false
               } else {
                self.myEndDate = dateFormatter.string(from: date)
               }
    }
    
    func showDatePicker(){
        datePicker = UIAlertDateTimePicker(withPickerMode: .date, pickerTitle: "Select Date", showPickerOn: self.view)
           datePicker?.delegate = self
           datePicker?.showAlert()
       }
}
