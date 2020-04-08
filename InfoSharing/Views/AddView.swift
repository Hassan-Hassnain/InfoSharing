//
//  AddView.swift
//  Aking
//
//  Created by Usama Sadiq on 4/7/20.
//  Copyright © 2020 Usama Sadiq. All rights reserved.
//

import UIKit

class CreateTodo: UIView {
    let ADDVIEW_XIB_NAME = "AddView"
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleTF: UITextField!
    
    var delegate:CreateTodoDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(ADDVIEW_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
    @IBAction func selectDate(_ sender: UIButton) {
        delegate?.startFromFromDidTapped()
    }
    @IBAction func selectTime(_ sender: Any) {
        delegate?.endToButtonDidTapped()
    }
    @IBAction func addNewTodo(_ sender: Any) {
        delegate?.addTodoDidTapped()
    }
}

