//
//  AllViewController.swift
//  My app project
//
//  Created by Ira Xavier Porchia on 3/13/21.
//

import UIKit
import RealmSwift
import ChameleonFramework

protocol AllViewControllerDelegate{
    func display(item: Items, bool: Bool, idx: IndexPath, arr: Results<Items>?)
}

class AllViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var itemsArray: Results<Items>?
    var editButtonPressed: Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    var delegate : AllViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
        searchBar.delegate = self
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 80.0
    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let reminder = itemsArray?[indexPath.row]{
            cell.textLabel?.text = reminder.name
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM/dd/y, h:mm a"
            cell.detailTextLabel?.text = dateFormat.string(from: reminder.date!)
            if reminder.date ?? Date() < Date(){
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editButtonPressed{
            delegate?.display(item: itemsArray?[indexPath.row] ?? Items(), bool: true, idx: indexPath, arr: itemsArray)
            dismiss(animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Edit Button Pressed
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        editButtonPressed = !editButtonPressed
        
        if editButtonPressed{
            for cell in tableView.visibleCells {
                cell.isSelected = true
                cell.selectionStyle = .gray
            }
        }else{
            for cell in tableView.visibleCells {
                cell.isSelected = false
                cell.selectionStyle = .none
            }
        }
    }
    
    func loadItems(){
        itemsArray = realm.objects(Items.self).sorted(byKeyPath: "date", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath){
        if let category = self.itemsArray?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(category)
                }
            }catch{
                print("Error deleting item, \(error)")
            }
        }
    }
    
}

extension AllViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemsArray = itemsArray?.filter("name CONTAINS[cd] %@", searchBar.text!)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            //makes the keyboard and cursor go away when you click the x
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
