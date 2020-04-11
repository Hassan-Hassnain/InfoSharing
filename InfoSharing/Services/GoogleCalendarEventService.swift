//
//  GoogleCalendarEventService.swift
//  InfoSharing
//
//  Created by Usama Sadiq on 4/11/20.
//  Copyright © 2020 Usama Sadiq. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher
import UIAlertDateTimePicker

let CLIENT_ID = "750374453418-363del5odp0q8a5f5oggsmqg78e0519i.apps.googleusercontent.com"


class GoogleCalendarEventService: UIViewController {
    
    var outPut = ""
    var startDate: Date?
    var endDate: Date?
    
    let scopes = [kGTLRAuthScopeCalendar]
//    let service = GTLRCalendarService()
    
    /// Creates calendar service with current authentication
     lazy var calendarService: GTLRCalendarService? = {
        let service = GTLRCalendarService()
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them
        service.shouldFetchNextPages = true
        // Have the service object set tickets to retry temporary error conditions
        // automatically
        service.isRetryEnabled = true
        service.maxRetryInterval = 15
        
        guard let currentUser = GIDSignIn.sharedInstance().currentUser,
            let authentication = currentUser.authentication else {
                return nil
        }
        
        service.authorizer = authentication.fetcherAuthorizer()
        return service
    }()
    
    var datePicker: UIAlertDateTimePicker?
    var myStartDate = ""
    var myEndDate = ""
    var isStartDate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = CLIENT_ID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        
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
        
        calendarService?.executeQuery(insertQuery) { (ticket, object, error) in
            if error == nil {
                print("Event inserted")
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
        
        getEvents()
    }
    
    // you will probably want to add a completion handler here
    func getEvents(for calendarId: String = "primary") {
        guard let service = self.calendarService else {
            return
        }

        // You can pass start and end dates with function parameters
        let startDateTime = GTLRDateTime(date: Calendar.current.startOfDay(for: Date()))
        let endDateTime = GTLRDateTime(date: Date().addingTimeInterval(60*60*24))
        
//        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
//        let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarId)     //orignal line
        eventsListQuery.timeMin = startDateTime
        eventsListQuery.timeMax = endDateTime

        calendarService?.executeQuery(eventsListQuery, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
        
//        calendarService?.executeQuery(, completionHandler: <#T##GTLRServiceCompletionHandler?##GTLRServiceCompletionHandler?##(GTLRServiceTicket, Any?, Error?) -> Void#>)
        _ = service.executeQuery(eventsListQuery, completionHandler: { (ticket, result, error) in
            print(error as Any)
            print(ticket as Any)
            print(result as Any)
            guard error == nil, let items = (result as? GTLRCalendar_Events)?.items else {
                return
            }
            
            if items.count > 0 {
                print(items)
                // Do stuff with your events
            } else {
                // No events
            }
        })
    }
    func getEvent(startDate: Date, endDate: Date) {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
            query.maxResults = 10
            query.timeMin = GTLRDateTime(date: startDate)
        query.timeMax = GTLRDateTime(date: endDate)
            query.singleEvents = true
            query.orderBy = kGTLRCalendarOrderByStartTime
            calendarService?.executeQuery(
                query,
                delegate: self,
                didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
        }

    
    
    // Helper to build date
    func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
        let datetime = GTLRDateTime(date: date)
        let dateObject = GTLRCalendar_EventDateTime()
        dateObject.dateTime = datetime
        return dateObject
    }
    
}

extension GoogleCalendarEventService: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
       
    }
    
    
}
extension GoogleCalendarEventService: UIAlertDateTimePickerDelegate {
    func positiveButtonClicked(withDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if isStartDate {
            myStartDate = dateFormatter.string(from: date)
            startDate = date
            isStartDate = false
        } else {
            endDate = date
            self.myEndDate = dateFormatter.string(from: date)
        }
    }
    
    func showDatePicker(){
        datePicker = UIAlertDateTimePicker(withPickerMode: .date, pickerTitle: "Select Date", showPickerOn: self.view)
        datePicker?.delegate = self
        datePicker?.showAlert()
    }
}

extension GoogleCalendarEventService {
    // Construct a query and get a list of upcoming events from the user calendar
    func fetchEvents() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 10
        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        calendarService?.executeQuery(
            query,
            delegate: self,
            didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }

    // Display the start dates and event summaries in the UITextView
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket, finishedWithObject response : GTLRCalendar_Events, error : NSError?) {

        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }

        var outputText = ""
        if let events = response.items, !events.isEmpty {
            for event in events {
                let start = event.start!.dateTime ?? event.start!.date!
                let startString = DateFormatter.localizedString(
                    from: start.date,
                    dateStyle: .short,
                    timeStyle: .short)
                outputText += "\(startString) - \(event.summary!)\n"
            }
        } else {
            outputText = "No upcoming events found."
        }
        outPut = outputText
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
