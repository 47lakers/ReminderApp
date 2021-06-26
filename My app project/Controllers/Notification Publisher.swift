//
//  Notification Publisher.swift
//  My app project
//
//  Created by Ira Xavier Porchia on 5/7/21.
//

import Foundation
import UIKit
import UserNotifications

class NotificationPublisher: NSObject{
    
    func sendNotification(title: String, subtitle: String, body: String, targetDate: Date, id: String, repeats: String){
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        
        // ********************************************
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        var trigger: UNCalendarNotificationTrigger
        var bool: Bool
        
        let year = calendar.component(.year, from: targetDate)
        let month = calendar.component(.month, from: targetDate)
        let weekday = calendar.component(.weekday, from: targetDate)
        let day = calendar.component(.day, from: targetDate)
        let hour = calendar.component(.hour, from: targetDate)
        let minute = calendar.component(.minute, from: targetDate)
        
        switch repeats{
        case "Daily":
            dateComponents.hour = hour
            dateComponents.minute = minute
            bool = true
            break;
        case "Weekly":
            dateComponents.weekday = weekday
            dateComponents.hour = hour
            dateComponents.minute = minute
            bool = true
            break;
        case "Monthly":
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = minute
            bool = true
            break;
        case "Yearly":
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = minute
            bool = true
            break;
        default:
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = minute
            bool = false
            break;
        }
        
        trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: bool)
        
        // ********************************************
        
        
        notificationContent.sound = UNNotificationSound.default
        
        UNUserNotificationCenter.current().delegate = self
        
        let request = UNNotificationRequest(identifier: id, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil{
                print("something went wrong")
            }
        }
        
    }
}

extension NotificationPublisher: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("The notification is about to be presented")
        completionHandler([.badge, .sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        
        switch identifier{
        
        case UNNotificationDismissActionIdentifier:
            print("The notification was dismissed")
            completionHandler()
            
        case UNNotificationDefaultActionIdentifier:
            print("The user opened the app from the notification")
            completionHandler()
            
        default:
            print("The default case was called")
            completionHandler()
        
        }
    }
}

// Replace alarms with settings and keyboard height and make it look pretty
