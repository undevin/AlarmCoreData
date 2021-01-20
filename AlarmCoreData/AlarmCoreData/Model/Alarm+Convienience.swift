//
//  Alarm+Convienience.swift
//  AlarmCoreData
//
//  Created by Karl Pfister on 1/19/21.
//

import Foundation
import CoreData

extension Alarm {

    /// `@discarableResult` indicates we have the option of ignoring the returned value from the initializer
    @discardableResult
    /**
     Initializes a Alarm object from a context

     - Parameters:
        - title: String value for the title attribute
        - isEnabled: Bool value for the enabled attribute, default value of `true`. All alarms are inherently on.
        - fireDate: Date value for the fireDate attribute - When the alarm will trigger
        - uuid: A randomly generated unique identifier. We use this string to keep track of each Alarm `Object`
        - context: The NSManagedObjectContext for the app, default value set to the CoreDataStack class's context property
     */

    convenience init(title: String, isEnabled: Bool = true, fireDate: Date, uuid: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.context) {

        self.init(context: context)
        self.title = title
        self.isEnabled = isEnabled
        self.fireDate = fireDate
        self.uuid = uuid

    }
}
