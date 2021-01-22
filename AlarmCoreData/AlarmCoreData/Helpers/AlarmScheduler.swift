//
//  AlarmScheduler.swift
//  AlarmCoreData
//
//  Created by Devin Flora on 1/21/21.
//

import UserNotifications

protocol AlarmScheduler: AnyObject {
    func scheduleUserNotifications(alarm: Alarm)
    func cancelUserNotifications(alarm: Alarm)
}

// MARK: - Extensions
extension AlarmScheduler {
    func scheduleUserNotifications(alarm: Alarm) {
        guard let alarmTime = alarm.fireDate,
              let title = alarm.title,
              let uuid = alarm.uuidString else { return }
        let notification = UNMutableNotificationContent()
        notification.title = "ALARM"
        notification.body = "Your alarm \(title) is going off!"
        notification.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alarmTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "\(uuid)", content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request: \(error)")
            }
        }
    }
    
    func cancelUserNotifications(alarm: Alarm) {
        guard let uuid = alarm.uuidString else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuid])
    }
}
