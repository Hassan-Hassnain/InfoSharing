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
    
    var datePicker: UIAlertDateTimePicker?
    var myStartDate = ""
    var myEndDate = ""
    var isStartDate = false
    var startDate: Date?
    var endDate: Date?
    
    var events: [CalendarEvent] = []
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        delegate = self
        
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
        guard let starTime = startDate,let endTime = endDate  else {
            print("please provide both dates")
            return
        }
        
        addEventoToGoogleCalendar(summary: titleTF.text!, description: descriptionTF.text!, startTime: starTime, endTime:endTime)
        
    }
    
    @IBAction func fetchEventButton(_ sender: Any) {
        getEvents(startDate: startDate!, endDate: endDate!)
    }
}
extension GoogleEventsVC: GoogleCalendarEventServiceDelegate {
    func didfetchResultUpdated(events: [CalendarEvent]) {
        self.events = events
        tableView.reloadData()
    }
}

extension GoogleEventsVC: UIAlertDateTimePickerDelegate {
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

extension GoogleEventsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCell") as! TVEvent
        cell.summery.text = calenderEvent[indexPath.row].Description
        cell.startTime.text = calenderEvent[indexPath.row].start
        cell.endTime.text = calenderEvent[indexPath.row].end
        return cell
    }
    
    
}

class TVEvent: UITableViewCell {
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var summery: UILabel!
    
}
