//
//  AlarmScheduler.swift
//  AlarmCoreData
//
//  Created by Karl Pfister on 1/19/21.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotification(for alarm: Alarm)
    func cancelUserNotification(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotification(for alarm: Alarm){

        let content = UNMutableNotificationContent()
        content.title = "Time to get up"
        content.body = "Your alarm named \(alarm.title!) is going off!"
        content.sound = UNNotificationSound.default

        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid!, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error{
                print("Error scheduling local user notifications \(error.localizedDescription)  :  \(error)")
            }
        }
    }

    func cancelUserNotification(for alarm: Alarm){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid!])
    }
}
