//
//  AlarmController.swift
//  AlarmCoreData
//
//  Created by Devin Flora on 1/21/21.
//

import CoreData

class AlarmController {
    
    // MARK: - Properties
    static let shared = AlarmController()
    
    var alarms: [Alarm] = []
    
    private lazy var fetchRequest: NSFetchRequest<Alarm> = {
        let request = NSFetchRequest<Alarm>(entityName: "Alarm")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - CRUD Methods
    func createAlarmWith(title: String, fireDate: Date) {
        let newAlarm = Alarm(title: title, fireDate: fireDate)
        alarms.append(newAlarm)
        CoreDataStack.saveContext()
        if newAlarm.isEnabled {
            scheduleUserNotifications(alarm: newAlarm)
        }
    }
    
    func fetchAlarms() {
        self.alarms = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    func update(alarm: Alarm, title: String, fireDate: Date, isEnabled: Bool) {
        alarm.title = title
        alarm.fireDate = fireDate
        alarm.isEnabled = isEnabled
        CoreDataStack.saveContext()
        if isEnabled {
            scheduleUserNotifications(alarm: alarm)
        } else {
            cancelUserNotifications(alarm: alarm)
        }
    }
    
    func toggleIsEnabled(alarm: Alarm) {
        alarm.isEnabled.toggle()
        CoreDataStack.saveContext()
        scheduleUserNotifications(alarm: alarm)
    }
    
    func delete(alarm: Alarm) {
        guard let index = alarms.firstIndex(of: alarm) else { return }
        alarms.remove(at: index)
        CoreDataStack.context.delete(alarm)
        cancelUserNotifications(alarm: alarm)
        CoreDataStack.saveContext()
    }
}//End of Class

// MARK: - Extension
extension AlarmController: AlarmScheduler { }
