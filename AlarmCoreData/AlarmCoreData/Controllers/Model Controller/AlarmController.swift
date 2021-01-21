//
//  AlarmController.swift
//  AlarmCoreData
//
//  Created by Karl Pfister on 1/19/21.
//

import Foundation
import CoreData

class AlarmController: AlarmScheduler {

    static let sharedInstance = AlarmController()
    // MARK:- Properties
    /**
     Source of Truth

     Creates an array of Alarm Objects. Sets the value to either the results of a fetchRequest or an empty array
     - fetchRequest: We set our fetchRequest to be *of type* a `NSFetchRequest` that can interact with `Alarm` objects

     - returns: The results of our fetch request *or* an empty array
     */
    var alarms: [Alarm] {
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }

    //MARK: - CRUD

    // Create
    /**
     Creates an `Alarm` object and calls the `saveToPersistentStore()` method to save it to persistent storage

     - Parameters:
        - title: String value to be passed into the `Alarm` initializer's `title` parameter
        - fireDate: Date value to be passed into the `Alarm` initializer's `fireDate` parameter
     */
    func createAlarm(withTitle title: String, and fireDate: Date) {
        /// Create the Alarm
       let alarm = Alarm(title: title, fireDate: fireDate)
        /// Schedule the alert
        scheduleUserNotification(for: alarm)
        /// Save the alarm
        saveToPersistentStore()
    }

    // Update
    /**
     Updates an existing `Alarm` object in persistent storage and and calls the `saveToPersistentStore()` method to save it with the updated values

     - Parameters:
        - alarm: The `Alarm` that needs to be updated
        - newTitle: String value to replace the `Alarm's` current title
        - newFireDate: Date value to replace the `Alarm's` current fireDate value
        - isEnabled: Bool value to replace the `Alarm's` current isEnabled value
     */
    func update(alarm: Alarm, newTitle: String, newFireDate: Date, isEnabled: Bool) {
        /// Cancel any pending notifications
        cancelUserNotification(for: alarm)
        /// Update the new values
        alarm.title = newTitle
        alarm.fireDate = newFireDate
        alarm.isEnabled = isEnabled
        /// Schedule the notification now that the fireDate has been updated
        scheduleUserNotification(for: alarm)
        /// Save the changes
        saveToPersistentStore()
    }

    /**
     Toggles a Alarm object's `isEnabled` boolean value and and calls the `saveToPersistentStore()` method to save it to persistent storage with the updated value

     - Parameters:
        - alarm: The `Alarm` that is being updated
     */
    func toggleIsEnabledFor(alarm: Alarm) {
        /// Update the isEnabled Property on the `alarm` to the opposite state
        alarm.isEnabled = !alarm.isEnabled
        /// I want this in the Model Controller because the `isEnabled` is a property on my model. We use a ternay operator below. If the `alarm.isEnabled` is equal to `true`, it will schedule the alert. Otherwise, it will cancel it.
        alarm.isEnabled ? scheduleUserNotification(for: alarm) : cancelUserNotification(for: alarm)
        /// Save it
        saveToPersistentStore()
    }

    // Delete
    /**
     Removes an existing `Alarm` object from the CoreDataStack context by calling the `delete()` method and then saves the context changes by calling `saveToPersistentStore()`

     - Parameters:
        - alarm: The `Alarm` to be removed from storage
     */
    func delete(alarm: Alarm) {
        /// Cancel any pending alerts
        cancelUserNotification(for: alarm)
        /// Delete the object
        CoreDataStack.context.delete(alarm)
        /// Save the Changes
        saveToPersistentStore()
    }

    /**
     Saves the current `CoreDataStack's` context to persistent storage by calling the `save()` method
     */
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object Context, item not saved")
        }
    }
} // End of class
