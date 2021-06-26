//
//  ViewController.swift
//  My app project
//
//  Created by Ira Xavier Porchia on 3/8/21.
//

import UIKit
import RealmSwift
import ChameleonFramework
import UserNotifications

class RemindMeViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var textView: UITextView!
//    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var backgroundText: UIView!
    
    var repeats = "None"
    var time = Date()
    var placeholderLabel : UILabel!
    let realm = try! Realm()
    let repeatsNumberIdx = ["None":0, "Daily":1, "Weekly":2, "Monthly":3, "Yearly":4]
    
    var editButtonPressed = false
    var idxPath = IndexPath()
    var itemsArray: Results<Items>?
    let notificationPublisher = NotificationPublisher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        placeholderLabel = UILabel()
        PlaceHolder(placeholderLabel: placeholderLabel, textView: textView)
        
        repeatButton.layer.cornerRadius = 0.5 * repeatButton.bounds.size.width
        repeatButton.clipsToBounds = true
        
        saveButton.layer.cornerRadius = 0.5 * saveButton.bounds.size.width
        saveButton.clipsToBounds = true
        
        clearButton.layer.cornerRadius = 0.5 * clearButton.bounds.size.width
        clearButton.clipsToBounds = true
        
        allButton.layer.cornerRadius = 0.5 * allButton.bounds.size.width
        allButton.clipsToBounds = true
        
        timeButton.layer.cornerRadius = 0.5 * timeButton.bounds.size.width
        timeButton.clipsToBounds = true
        
        textView.backgroundColor = UIColor.clear
        backgroundText.layer.cornerRadius = backgroundText.layer.bounds.width/2
        backgroundText.clipsToBounds = true
    }
    
    //MARK: - TextView Methods
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let str = (textView.text + text)
        if str.count <= 35 {
            return true
        }
        textView.text = String(str[..<str.index(str.startIndex, offsetBy: 35)])
        placeholderLabel.isHidden = true
        return false
    }
    
    //MARK: - IBActions

    @IBAction func repeatButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRepeat", sender: self)
    }
    
    @IBAction func goToTime(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToTime", sender: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if editButtonPressed{
            if let category = self.itemsArray?[idxPath.row]{
                do{
                    try self.realm.write{
                        self.realm.delete(category)
                    }
                }catch{
                    print("Error deleting item, \(error)")
                }
            }
            editButtonPressed = false
        }
        
        let newItem = Items()
        newItem.name = textView.text!
        newItem.date = time
        newItem.repeats = repeats
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/y, h:mm a"
        newItem.id = "\(UUID())"
        if newItem.name != ""{
            self.saveItems(item: newItem)
        }
            
        textView.text = nil
        PlaceHolder(placeholderLabel: placeholderLabel, textView: textView)
        
        time = Date()
        repeats = "None"
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    @IBAction func dateButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToDate", sender: self)
    }
    
    @IBAction func allButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAll", sender: self)
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        textView.text = nil
        PlaceHolder(placeholderLabel: placeholderLabel, textView: textView)
        
        editButtonPressed = false
        time = Date()
        repeats = "None"
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAll"{
            let secondVC = segue.destination as! AllViewController
            secondVC.delegate = self
        }
        
        if segue.identifier == "goToRepeat"{
            let secondVC = segue.destination as! RepeatsViewController
            secondVC.delegate = self
            secondVC.idx = repeatsNumberIdx[repeats] ?? 0
        }
        
        if segue.identifier == "goToTime"{
            let secondVC = segue.destination as! TimeViewController
            secondVC.delegate = self
            secondVC.date = time
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveItems(item: Items) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/y, h:mm a"
        
        switch repeats{
        case "Daily":
            notificationPublisher.sendNotification(title: "RemindMe", subtitle: item.name, body: dateFormat.string(from: time), targetDate: item.date ?? Date(), id: item.id ?? "id", repeats: "Daily")
            break;
        case "Weekly":
            notificationPublisher.sendNotification(title: "RemindMe", subtitle: item.name, body: dateFormat.string(from: time), targetDate: item.date ?? Date(), id: item.id ?? "id", repeats: "Weekly")
            break;
        case "Monthly":
            notificationPublisher.sendNotification(title: "RemindMe", subtitle: item.name, body: dateFormat.string(from: time), targetDate: item.date ?? Date(), id: item.id ?? "id", repeats: "Monthly")
            break;
        case "Yearly":
            notificationPublisher.sendNotification(title: "RemindMe", subtitle: item.name, body: dateFormat.string(from: time), targetDate: item.date ?? Date(), id: item.id ?? "id", repeats: "Yearly")
            break;
        default:
            notificationPublisher.sendNotification(title: "RemindMe", subtitle: item.name, body: dateFormat.string(from: time), targetDate: item.date ?? Date(), id: item.id ?? "id", repeats: "None")
            break;
        }

        
        do{
            try realm.write{
                realm.add(item)
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
}

extension RemindMeViewController: AllViewControllerDelegate{
    func display(item: Items, bool: Bool, idx: IndexPath, arr: Results<Items>?) {
        textView.text = item.name
        time = item.date ?? Date()
        repeats = item.repeats
        placeholderLabel.isHidden = true
        editButtonPressed = bool
        idxPath = idx
        itemsArray = arr
        navigationController?.navigationBar.barTintColor = UIColor.red
    }
}

extension RemindMeViewController: RepeatsViewControllerDelegate{
    func repeats(name: String) {
        repeats = name
    }
}

extension RemindMeViewController: TimeViewControllerDelegate{
    func time(dateVar: Date) {
        time = dateVar
    }
}

