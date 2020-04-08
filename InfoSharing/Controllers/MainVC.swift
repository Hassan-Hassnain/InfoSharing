//
//  MainVC.swift
//  InfoSharing
//
//  Created by Usama Sadiq on 4/8/20.
//  Copyright © 2020 Usama Sadiq. All rights reserved.
//

import UIKit
import UIAlertDateTimePicker
import Firebase

class MainVC: UITableViewController {
    
    var createTodo: CreateTodo!
    var todos: [Task] = []
    var datePicker: UIAlertDateTimePicker?
    var todo = Task(name: "", updateTime: "", task: "", startTime: "", endTime: "")
    var isStartDate: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAddView()
        
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        createTodo?.isHidden = false
    }
    fileprivate func showAddView() {
        createTodo = CreateTodo()
        createTodo?.delegate = self
        createTodo!.tag = 100
        createTodo?.isHidden = true
        view.addSubview(createTodo!)
        createTodo!.fixInView(self.view)
       }
    func setupDatePicker(){
        datePicker = UIAlertDateTimePicker(withPickerMode: .dateAndTime, pickerTitle: "Select Date", showPickerOn: self.view)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        cell.configure(task: todos[indexPath.row])
        return cell
    }
  
    
}
extension MainVC: CreateTodoDelegate {
    
    func startFromFromDidTapped() {
        isStartDate = true
        showDatePicker()
    }
    
    func endToButtonDidTapped() {
        showDatePicker()
    }

    func addTodoDidTapped() {
        if let title = createTodo.titleTF.text {
            todo.task = title
        }
        DataService.instance.getUserData(forUID: Auth.auth().currentUser!.uid) { (user) in
            self.todo.updateTime = Date.getFormattedDate(date: Date())
            self.todo.name = user.name
            self.todos.append(self.todo)
            self.tableView.reloadData()
            print(self.todos.count)
            self.createTodo?.isHidden = true
        }
        
        
    }
    
    func showDatePicker(){
        datePicker = UIAlertDateTimePicker(withPickerMode: .dateAndTime, pickerTitle: "Select Date", showPickerOn: self.view)
        datePicker?.delegate = self
        datePicker?.showAlert()
    }
    
}

extension MainVC: UIAlertDateTimePickerDelegate {
    func positiveButtonClicked(withDate date: Date) {
        print(Date.getFormattedDate(date: date))
        if isStartDate {
            self.todo.startTime = Date.getFormattedDate(date: date)
            isStartDate = false
        } else {
            self.todo.endTime = Date.getFormattedDate(date: date)
        }
    }
    
    
}
