//
//  AlarmTableViewCell.swift
//  AlarmCoreData
//
//  Created by Karl Pfister on 1/19/21.
//

import UIKit

/**
The protocol we will use to handle the updating of the cell when the `isEnabledButton` is toggled
   - `class`: This protocol can interact with class level objects

Step One:
   - Define the protocol. This will need to interact with class level objects.

Delegate Methods:
   - alarmWasToggled(sender: AlarmTableViewCell)

*/
protocol AlarmTableViewCellDelegate: class{
    /**
     Delegate method for the `AlarmTableViewCellDelegate`
     
     Parameters:
     - sender: The cell that that user toggled
     */
    func alarmWasToggled(sender: AlarmTableViewCell)
}


class AlarmTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var alarmTitleLabel: UILabel!
    @IBOutlet weak var alarmFireDateLabel: UILabel!
    @IBOutlet weak var isEnabledSwitch: UISwitch!

    /**
     The `delegate` or *intern* for the protocol `AlarmTableViewCellDelegate`

     - weak: We mark this method as weak to not create a retain cycle
     - optional: We do not want to set the value of the delegate here.
     */
    weak var delegate: AlarmTableViewCellDelegate?

    //MARK: - Helper Functions
   func updateViews(with alarm: Alarm) {
        alarmTitleLabel.text = alarm.title
    /// We can be confident with `Force Unwrapping` the `fireDate` because a alarm can not be created without one.
        alarmFireDateLabel.text = alarm.fireDate!.stringValue()
        isEnabledSwitch.isOn = alarm.isEnabled
    }

    //MARK: - Actions
    @IBAction func isEnabledSwitchToggled(_ sender: Any) {
        /// This is the call to action for the delegate. Hey intern, go get me a coffee
        delegate?.alarmWasToggled(sender: self)
    }
}
