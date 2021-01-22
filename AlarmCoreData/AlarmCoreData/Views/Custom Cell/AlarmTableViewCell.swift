//
//  AlarmTableViewCell.swift
//  AlarmCoreData
//
//  Created by Devin Flora on 1/21/21.
//

import UIKit

// MARK: - Protocols
protocol AlarmTableViewCellDelegate: AnyObject {
    func alarmWasToggled(sender: AlarmTableViewCell)
}

class AlarmTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var alarmTitleLabel: UILabel!
    @IBOutlet weak var alarmFireDateLabel: UILabel!
    @IBOutlet weak var isEnabledSwitch: UISwitch!
    
    // MARK: - Properties
    weak var delegate: AlarmTableViewCellDelegate?
    
    
    
    // MARK: - Actions
    @IBAction func isEnabledSwitchToggled(_ sender: UISwitch) {
        delegate?.alarmWasToggled(sender: self)
    }
    
    // MARK: - Methods
    func updateViews(alarm: Alarm) {
        alarmTitleLabel.text = alarm.title
        alarmFireDateLabel.text = DateFormatter.alarmTime.string(from: alarm.fireDate ?? Date())
        isEnabledSwitch.isOn = alarm.isEnabled
    }
}//End of Class
