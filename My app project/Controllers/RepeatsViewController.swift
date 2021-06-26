//
//  RepeatsViewController.swift
//  My app project
//
//  Created by Ira Xavier Porchia on 3/11/21.
//

import UIKit
import RealmSwift

protocol RepeatsViewControllerDelegate{
    func repeats(name: String)
}

class RepeatsViewController: UITableViewController {
    
    var delegate : RepeatsViewControllerDelegate?
    
    let repeatsArray = ["None", "Daily", "Weekly", "Monthly", "Yearly"]
    var idx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        let indexPath = IndexPath(row: idx, section: 0)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.tableView.delegate?.tableView!(self.tableView, didSelectRowAt: indexPath)
        
        tableView.rowHeight = 80.0
        
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = repeatsArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        
        if indexPath != IndexPath(row: idx, section: 0){
            let indexPath2 = IndexPath(row: idx, section: 0)

            self.tableView.deselectRow(at: indexPath2, animated: true)
            self.tableView.delegate?.tableView!(self.tableView, didDeselectRowAt: indexPath2)
        }
        
        delegate?.repeats(name: tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "Error")
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }

}


