# AlarmCoreData

# Alarm
Students will build a simple alarm app to practice intermediate table view features, protocols, the delegate pattern, CoreData, and UserNotifications.

## Part One - Defining Model
### Basic set-up 

Fork, then clone this repository. Change your working branch to `Starter`. 

Take a moment and look through the project and get familiar with the current state. You’ll notice that you have a Xcode project with `CoreData` already imported to the project. The `xcdatamodel` is blank, you have some basic file structure, your `info.plist` has been moved and updated, and the default `ViewController` has been deleted. 

If you don’t see anything, you likely need to pull from the remote starter branch.

On the `storyboard` file you should see two `TableViewControllers`. The first `TableViewController` has a custom cell with two labels, and a UI Switch. The labels have default text that signifies what data they will showcase. The Switch is set to `On` and will be uses to toggle if the alarm should be active or not. 

The second TableViewController has three `static` sections. Within each cell in each section is a single view element. Section `0` has a `UIDatePicker` that has been set to Date, and Time. Section `1` has a `TextField` the user will use to give their alarm a title. Section `2` has a button that the user will use to toggle if the alarm should be active or not. 

 There is are two separate segues - one from the (+) button and one from the cell. 

It’s good practice to run the app here and see if it builds. You should see a tableview with a plus button. When pressing that (+) button you navigate to the detail view. 

Go back through the storyboard and write down what items are missing. Are the views subclassed? Are the segues or cells properly identified?
---

### Define the Model. 

The `.xcuserDataModel` is the true model for this application. Its here were we will define the properties. Create a new Entity named `Alarm` and give it four properties. In no particular order — fireDate, isEnabled, title, and UUIDString. What data type do you think matches these properties best?

        - title: String value for the title attribute
        - isEnabled: Bool value for the enabled attribute, default value of `true`. All alarms will be inherently on.
        - fireDate: Date value for the fireDate attribute - When the alarm will trigger
        - uuidString: A randomly generated unique identifier. We use this string to keep track of each Alarm `Object`

Define those properties in your `.xcdatamodel`.

---

### Convienience Initializer

Create a `swift` file named `Alarm+convienience`. There are a few different types of initializers we can use to create our `Alarm` objects, but there is not one that is perfect for it. To create an initializer that will allow us to pass in all the values we want we define what’s called a `convenience Initializer`

Explore [Initializers and Convenience Initializers](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html) in Apples documentation.


Convenience initializers are written in the same style as normal designated, or member-wise, initializers; with the `convenience` modifier placed before the `init `keyword, separated by a space.  

	* `convenience init(){}`

Extend `Alarm` and create your convenience initializer inside of the extension

1. Import `CoreData`
2. Make sure the initializer has parameters for `title`, `isEnabled,` `fireDate`, `uuidString`, and `context` and that each parameter takes in the right type.  `context` will be of type `NSManagedObjectContext`
3. Define uuidString to have a default value of a `UUID`class initialized, specially the `uuidString` property.
		1. `UUID().uuidString`
4. Define `context`  with a default value of `CoreDataStack.context`.
5. Inside the body of the initializer set your `Alarm` properties and call the `NSManagedObject` convenience initializer and pass in context from your own convenience initializer
		1. `self.init(context: context)`

---

## The Model is now complete. Take a 5 min break and see the sun, or whatever.
---

# Part Two - Model Controller
### AlarmController (Model Controller Object)

Create an `AlarmController` model object controller that will manage and serve `Alarm` objects to the rest of the application.

1. Create a `AlarmController.swift` file and define a new `AlarmController `class inside
2. Create a `sharedInstance` property and assign a value of a `AlarmController` initialized 
3. Add a `alarms`  computed property and set it to be an array of `Alarm`objects. Create a fetch request within the computed property and `return` the results of the fetch request. 
4. Create the following CRUD function signatures:
	* `createAlarm(withTitle title: String, and fireDate: Date)`
	* `update(alarm: Alarm, newTitle: String, newFireDate: Date, isEnabled: Bool)`
	* `toggleIsEnabledFor(alarm: Alarm)`
	* `delete(alarm: Alarm)`
	* `saveToPersistentStore()`
	
### Build out the CRUD methods
1. Create should create a `Alarm` object and then call your `saveToPersistentStore()`
2. Update should update the passed in `Alarm`  object with the new values that were passed in. Should you save here?
3. toggleIsEnabledFor should simply flip the boolean status of a `Alarm` isEnabled property. Surely you should save this too.
4. Delete should access the context on the `CoreDataStack` and call the delete method. As always, let’s save that change.
5. saveToPersistentStore should access the context on the `CoreDataStack` and call the save method — or at least `try` to. Be sure to `catch`

## The Model Controller is now 80% complete. 
---

# Part Three - Wire up the views
### Lets start with our Custom TableView Cell
Build a custom table view cell to display an  `Alarm` objects data. The cell should display the `title`, the `fireDate` and have a `switch`  to display and toggle wether the `Alarm` is enabled or not.

1. Add a new `cocoa touch class`file called `AlarmTableViewCell` as a subclass of `UITableViewCell `
	1. Delete the awakeFromNib() and setSelected() functions
2. Assign the new class to the prototype cell on the first `TableViewController ` scene in `Main.storyboard`
3. Create an IBOutlet for the `alarmTitleLabel`
4. Create an IBOutlet for the `alarmFireDateLabel`
5. Create an IBOutlet for the `Switch` , name it `isEnabledSwitch`
6. Create an IBAction for the `Switch` named `isEnabledSwitchToggled` which you will implement using a custom protocol in the next step

### Implement the update views pattern on the TaskTableViewCell

1. Add an `updateViews()` function that takes in a parameter of type `Alarm`. 
2. In the body of this function assign the `Alarm` properties to their corresponding outlets.
	1. `alarmTitleLabel.text =`
	2. `alarmFireDateLabel.text = `
	3. `isEnabledSwitch.isOn` 

# Stop. You should have an error. 
The `alarmFireDateLabel.text` can only accept `String` but we only really have a `Date` value to give. Take a moment and do a search online for how to convert a `Date` to a `String`. 

Wouldn’t it be cool if we could override how the `Date` struct works and give it the ability to convert to a `String` automatically? Because we are iOS Developers and basically Jedi - we can do many things that others may consider… unnatural.

Rather than writing all the logic to convert a `String` from `Date` here in the `updateViews` function, we can clean up our code and explore extensions even more in-depth.  Comment out or delete the code you wrote assigning a value to the `alarmFireDateLabel.text`

# Custom String Extension 
	1. Create a new `.swift` file named `DateHelper`
	2. Extend the `Date` struct
	3. Declare a function called `stringValue` and return a `String`
	4. Within the `stringValue` function initialize a `DateFormatter` class named `formatter`
	5. Set the `dateStyle` to your preferred style. I prefer `.medium`
	6. Set the `timeStyle` to your preferred style. I prefer `.medium`
	7. Return the `formatter.string` from self.

``` swift
func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
```


Navigate back to your custom cell and set the `alarmFireDateLabel.text` value to `alarm.fireDate!.stringValue()`. We can be confident in `FORCE UNWRAPPING` the `fireDate` because a `Alarm` object cannot be initialized without one. 

How cool is that? 


---

# Custom Protocol
In this next section, you will write a `protocol` for the `AlarmTableViewCell `to delegate handling a 	switch toggle to the `AlarmListTableViewController`, which we have not created yet, adopt the protocol, and use the delegate method to  update the `isEnabled` and reload the cell.

1. Declare a protocol named `AlarmTableViewCellDelegate` to the top of your `AlarmTableViewCell`.swift file
	1. Remember, Protocols are declared above the class
2. In the body of your protocol, define a `alarmWasToggled(sender: AlarmTableViewCell)`function
	1. (Keep in mind, you only declare a function signature in the protocol, no body)
3. Declare the protocol can interact with class level objects
	1. `: class`
4. Add a weak optional delegate property on the AlarmTableViewCell
	1. Hint: remember to make this a weak var*
5. Call the delegates protocol function in the `isEnabledSwitchToggled` IBAction

### Great Work! Nice custom cell and custom Protocol / Delegate!

---

# AlarmListTableViewController
Lets wire up our first `TableViewController`

1. Add a new `cocoa touch class`file called `AlarmListTableViewController` as a subclass of `UITableViewController` 
2. Add a new `cocoa touch class`file called `AlarmDetailTableViewController` as a subclass of `UITableViewController` 
3. Recall that the first  `TableViewController` has no subclass. Subclass it now with the `listVC`
4. Recall that the second `TableViewController` has no subclass. Subclass it now with the `detailVC`
5. Remove any unneeded boilerplate code
6. Implement the `UITableViewDatasource` functions using the `alarms` source of truth
7. In the `cellForRow(at:)` optionally type cast the cell to be your custom cell.
	1. Set the cells identifier here and on the `storyboard`
	2. Using the cells `row` property on the `indexPath` pull the `alarm` from the source of truth
	3. Call the `updateViews` function on the cell and pass in the `alarm`

We now need to set the `AlarmListTableViewController` to be the delegate for the protocol we declared on the `AlarmTableViewCell` file. 

1. Extend the `AlarmListTableViewController` to adopt the `AlarmTableViewCellDelegate` protocol. 
	1. Add required protocol stubs
	2. Get the `indexPath` for the sender
	3. Using the `row` property of the `indexPath` you just created pull out the corresponding `alarm` object
	4. Call the `toggleIsEnabledFor(alarm` function from your Model Controller
	5. Call the `updateViews(with:)` function on the sender
	6. Navigate back to the `cellForRow(at:)` and assign your delegate
	7. Rejoice for your protocol and delegate is complete. 

Fill in the `prepare(for segue: UIStoryboardSegue, sender: Any?)` function on the `AlarmListTableViewController` to properly prepare the next view controller for the segue.

1. Identify what segue was triggered
	1. If you have not already, now would be a great time to set the segue identifier on the `storyboard`
2. Identify what the `indexPath` for the cell that triggered this segue. Be sure to properly guard against a nil value.
3. Optionally type cast the `destination` of the segue to the `AlarmDetailViewController`. Be sure to properly guard against this failing
4. Using the `row` property of the `indexPath` you created above, pull out the corresponding `Alarm` object
5. Assign this `alarm` to the `alarm` recover on the `AlarmDetailViewController`
	1. This has not been created yet. Navigate to the `AlarmDetailViewController` and declare an optional `Alarm` object. 

All we have left to do now is the delete method. Please implement that now. 

### Victory over the first TableViewController

---

# AlarmDetailViewController
Let’s wire up our second `TableViewController`. This should already be subclassed because of an earlier step, if it’s not, please do so now.

1. If you have not already, declare your receiver
	1. Declare an optional `Alarm` object. 
2. Remove any unneeded boilerplate code
3. We need a way to keep track of if the alarm is enabled. Declare a Bool named `isAlarmOn`  and set the default value to `true`.
4. Create an IBOutlet for the `alarmFireDatePicker`
5. Create an IBOutlet for the `alarmTitleTextField`
6. Create an IBOutlet for the `Button` , name it `alarmIsEnabledButton`
7. Create an IBAction for the on `Button` , name it `alarmIsEnabledButtonTapped`
8. Create an IBAction for the save `Button` , name it `saveButtonTapped`
9. Create the following helper method signatures:
	* `updateView()`
	* `designIsEnabledButton()`


### Build out the helper functions

Lets start with `updateViews()`

1. updateView needs to guard against the `alarm` receiver not having a value. 
2. With the unwrapped `alarm` we can set the proper values to the `alarmFireDatePicker` and  `alarmTitleTextField`. 
3. Update the `isAlarmOn` Bool to the value of the `isEnabled` property on the `alarm`
4. Call your `designIsEnabledButton()`Here

Lets finish up the `designIsEnabledButton` function

1. write a `switch` statement on the `isAlarmOn` property with two cases `true` and `false`
		1. For the `true` case set the `backgroundColor` of the `alarmIsEnabledButton` to a color of your choosing. I like `.white`
		2. Set the title of the `alarmIsEnabledButton` to a string of your choosing. I like “Enabled”
		3. For the `false` case set the `backgroundColor` of the `alarmIsEnabledButton` to a color of your choosing. I like `.darkGray`
		4. Set the title of the `alarmIsEnabledButton` to a string of your choosing. I like “Disabled”

``` swift
func designIsEnabledButton() {
        switch isAlarmOn {
        case true:
            alarmIsEnabledButton.backgroundColor = .white
            alarmIsEnabledButton.setTitle("Enabled", for: .normal)
        case false:
            alarmIsEnabledButton.backgroundColor = .darkGray
            alarmIsEnabledButton.setTitle("Disabled", for: .normal)
        }
    }
```

---

### Implement the saveButtonTapped

	1. Unwrap the `text` from the `alarmTitleTextField`, and check to make sure the value is `not` and empty string.
	2. Conditionally unwrap the `alarm` receiver
		1. If the `receiver` has a valid value call your `update(alarm:` function from your `sharedInstance`
		2. If the `reciever` does not have a valid value call your `createAlarm(withTitle)` function from your `sharedInstance`
	3. Pop this ViewController off the view stack 

### Implement the alarmIsEnabledButtonTapped

2. Conditionally unwrap the `alarm` receiver
		1. If the `receiver` has a valid value call your `utoggleIsEnabledFor` function from your `sharedInstance`
			1. Set the `isAlarmOn` property to the value of the `isEnabled` property of the `alarm`
		2. If the `reciever` does not have a valid value call set the `isAlarmOn` property to the opposite value
		3. Call your `designIsEnabledButton` function outside of the conditional unwrap but within the @IBAction

Build and run the application. Check for bugs. At this point you should have a solid working application. The alarms should be able to be created, updated, and persist across app launches. The final task is to implement User Notifications to alert the user when their alarm triggers. 

---

# Part Three - Register the App for UserNotifications
Register for local notifications when the app launches.

1. In the `AppDelegate.swift` file adopt the  `UNUserNotificationCenterDelegate` protocol.
2. Then in the `application(_:didFinishLaunchingWithOptions:)` function, request notification authorization on an instance of `UNUserNotificationCenter`.
* note: See UserNotifications Documentation for furthur instrution: https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications
```swift
UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (accepted, error) in
            if !accepted{
                print("Notification access has been denied")
            }
        }
        UNUserNotificationCenter.current().delegate = self
```

### Schedule and Cancel Local Notifications using a Custom Protocol and Extension

You will need to schedule local notifications each time you enable an alarm and cancel local notifications each time you disable an alarm. Seeing as you can enable/disable an alarm from both the list and detail view, we normally would need to write a `scheduleUserNotifications(for alarm: Alarm)` function and a `cancelUserNotifications(for alarm: Alarm)` function on both of our view controllers. However, using a custom protocol and a protocol extension, we can write those functions only once and use them in each of our view controllers as if we had written them in each view controller.

You will need to heavily reference Apples documentation on UserNotifications: https://developer.apple.com/documentation/usernotifications

1. Create a new `.swift` file named  `AlarmScheduler` 
2. Declare a `protocol AlarmScheduler`. This protocol will need two functions: `scheduleUserNotifications(for alarm:)` and `cancelUserNotifications(for alarm: Alarm)`.
3. Below your protocol, create a protocol extension, `extension AlarmScheduler`. In there, you can create default implementations for the two protocol functions.
4. Your `scheduleUserNotifications(for alarm: Alarm)` function should create an instance of `UNMutableNotificationContent` and then give that instance a title and body. You can also give that instance a default sound to use when the notification goes off using `UNNotificationSound.default()`.
5. After you create your `UNMutableNotificationContent`, create an instance of `UNCalendarNotificationTrigger`. In order to do this you will need to create `DateComponents` using the `fireDate` of your `alarm`.

* note: Use the `current` property of the  `Calendar` class to call a method which returns dateComponents from a date.

* note: Be sure to set `repeats` in the `UNCalendarNotificationTrigger` initializer to `true` so that the alarm will repeat daily at the specified time.

5. Now that you have `UNMutableNotificationContent` and a `UNCalendarNotificationTrigger`, you can initialize a `UNNotificationRequest` and add the request to the notification center object of your app.

* note: In order to initialize a `UNNotificationRequest` you will need a unique identifier. If you want to schedule multiple requests (which we do with this app) then you need a different identifier for each request. Thus, use the `uuidString` property on your `Alarm` object as the identifier.

6. Your `cancelLocalnotification(for alarm: Alarm)` function simply needs to remove pending notification requests using the `uuid` property on the `Alarm` object you pass into the function.

* note: Look at documentation for `UNUserNotificationCenter` and see if there are any functions that will help you do this.  https://developer.apple.com/documentation/usernotifications/unusernotificationcenter/1649517-removependingnotificationrequest

7. Navigate back to your model controller and conform your `AlarmController` Class to the `AlarmScheduler` protocol. Notice how the compiler does not make you implement the schedule and cancel functions from the protocol? This is because by adding an extension to the protocol, we have created default implementation of these functions for all classes that conform to the protocol.
8. Go through each of the CRUD functions and schedule / cancel the User Notifications based on the needs of that method. 
	1. When a an alarm is created it will need the alert scheduled.
	2.  When an alarm is updated cancel the first alert and then schedule the new one after the update is applied.
	3. When you when the alarm is enabled and disabled handle the notifications accordingly
	4. When an alarm is deleted we need to cancel the alert 
	
### UNUserNotificationCenterDelegate

The last thing you need to do is set up your app to notify the user when an alarm goes off and they still have the app open. In order to do this we are going to use the `UNUserNotificationCenterDelegate` protocol.

1. In your `application(_:didFinishLaunchingWithOptions:)` function, set the delegate of the notification center to equal `self`.
* note: `UNUserNotificationCenter.current().delegate = self`
2. Then call the delegate method `userNotificationCenter(_:willPresent:withCompletionHandler:)` and use the `completionHandler` to set your `UNNotificationPresentationOptions`.
* note: `completionHandler([.alert, .sound])`

Build and run the app. Check for bugs. At this time, you should have a full working application that used a Protocol and Delegate, a custom Protocol, and uses local alerts. Well done!  
## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2019- 2020. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
