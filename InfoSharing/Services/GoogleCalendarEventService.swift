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
//import UIAlertDateTimePicker

let CLIENT_ID = "750374453418-363del5odp0q8a5f5oggsmqg78e0519i.apps.googleusercontent.com"

protocol GoogleCalendarEventServiceDelegate {
    func didfetchResultUpdated(events: [CalendarEvent]) -> Void
}

class GoogleCalendarEventService: UIViewController {
    
    var delegate: GoogleCalendarEventServiceDelegate?
    
    var calenderEvent: [CalendarEvent] = [] { didSet { delegate?.didfetchResultUpdated(events: calenderEvent)}  }
    
    let scopes = [kGTLRAuthScopeCalendar]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = CLIENT_ID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance()?.presentingViewController = self
         
    }
    
    func addEventoToGoogleCalendar(summary : String, description :String, startTime : Date, endTime : Date) {
        let calendarEvent = GTLRCalendar_Event()
        
        calendarEvent.summary = "\(summary)"
        calendarEvent.descriptionProperty = "\(description)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        let toBuildDateStart = startTime
        let toBuildDateEnd = endTime
        
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
    }
    
    // you will probably want to add a completion handler here
    func getEvents(startDate: Date, endDate: Date) {
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
    
    // Display the start dates and event summaries in the UITextView
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket, finishedWithObject response : GTLRCalendar_Events, error : NSError?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        calenderEvent = []
        if let events = response.items, !events.isEmpty {
            for event in events {
                let start = event.start!.dateTime ?? event.start!.date!
                let startString = DateFormatter.localizedString( from: start.date, dateStyle: .short, timeStyle: .short)
                let end = event.end!.dateTime ?? event.end!.date!
                let endString = DateFormatter.localizedString( from: end.date, dateStyle: .short, timeStyle: .short)
                let summery = event.summary ?? ""
                
                let evnt = CalendarEvent(Description: summery, start: startString, end: endString)
                calenderEvent.append(evnt)
            }
        } else {
            calenderEvent = []
        }
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

extension GoogleCalendarEventService: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

struct CalendarEvent {
    //    var title: String
    var Description: String
    var start: String
    var end: String
}
