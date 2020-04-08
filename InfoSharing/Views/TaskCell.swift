//
//  TaskCell.swift
//  InfoSharing
//
//  Created by Usama Sadiq on 4/8/20.
//  Copyright © 2020 Usama Sadiq. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTiemLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String, updateTime: String, task: String, startTime: String, endTime: String) {
        self.nameLabel.text = name
        self.updateTimeLabel.text = updateTime
        self.taskLabel.text = task
        self.startTimeLabel.text = startTime
        self.endTiemLabel.text = endTime
    }
    func configure(task: Task) {
        self.nameLabel.text = task.name
        self.updateTimeLabel.text = task.updateTime
        self.taskLabel.text = task.task
        self.startTimeLabel.text = task.startTime
        self.endTiemLabel.text = task.endTime
    }

}
