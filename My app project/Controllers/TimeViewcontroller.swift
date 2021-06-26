//
//  TimeViewcontroller.swift
//  My app project
//
//  Created by Ira Xavier Porchia on 6/10/21.
//

import Foundation
import UIKit

protocol TimeViewControllerDelegate{
    func time(dateVar: Date)
}

class TimeViewController: UIViewController{
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var date = Date()
    
    var delegate : TimeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = date
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        date = sender.date
        delegate?.time(dateVar: date)
    }
}
