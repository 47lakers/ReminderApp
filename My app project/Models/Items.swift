//
//  AllReminders.swift
//  My app project
//
//  Created by Ira Xavier Porchia on 3/15/21.
//

import Foundation
import RealmSwift

class Items: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var repeats: String = "None"
    @objc dynamic var date: Date?
    @objc dynamic var id: String?
    
    
//    @objc dynamic var sound:

}
