//
//  Date++.swift
//  Aking
//
//  Created by Usama Sadiq on 4/7/20.
//  Copyright © 2020 Usama Sadiq. All rights reserved.
//

import UIKit



extension Date {
    static func getFormattedDate(date: Date) -> String {
        let dateformat = DateFormatter()
//        dateformat.dateFormat = "MMM d/yyyy"              //Apr 8/2020
//        dateformat.dateFormat = "MMM dd-yyyy HH:mm"         //Apr 08-2020 03:14
        dateformat.dateFormat = "MMM dd-yyyy HH:mm a"
        return dateformat.string(from: date)
    }
}


extension UIView {
    func addShadow(){
       layer.shadowColor = UIColor.black.cgColor
       layer.shadowOffset = CGSize(width: 0, height: 3)
       layer.shadowOpacity = 0.1
       layer.shadowRadius = 4.0
    }

    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
