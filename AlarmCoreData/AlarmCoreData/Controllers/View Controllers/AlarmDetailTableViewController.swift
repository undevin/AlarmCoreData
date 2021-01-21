//
//  AlarmDetailTableViewController.swift
//  AlarmCoreData
//
//  Created by Karl Pfister on 1/19/21.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    //MARK: - Properties
    var alarm: Alarm?
    var isAlarmOn: Bool = true

    //MARK: - Outlets
    @IBOutlet weak var alarmFireDatePicker: UIDatePicker!
    @IBOutlet weak var alarmTitleTextField: UITextField!
    @IBOutlet weak var alarmIsEnabledButton: UIButton!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    //MARK: - Helper Functions
    func updateView() {
        guard let alarm = alarm else {return}
        alarmFireDatePicker.date = alarm.fireDate!
        alarmTitleTextField.text = alarm.title
        isAlarmOn = alarm.isEnabled
        designIsEnabledButton()
    }

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

    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = alarmTitleTextField.text, title != "" else {return}


        if let alarm = alarm{
            AlarmController.sharedInstance.update(alarm: alarm, newTitle: title, newFireDate: alarmFireDatePicker.date, isEnabled: isAlarmOn)
        } else{
            AlarmController.sharedInstance.createAlarm(withTitle: title, and: alarmFireDatePicker.date)
        }
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func alarmIsEnabledButtonTapped(_ sender: Any) {
        if let alarm = alarm {
            AlarmController.sharedInstance.toggleIsEnabledFor(alarm: alarm)
            isAlarmOn = alarm.isEnabled
        }else{
            isAlarmOn = !isAlarmOn
        }
        designIsEnabledButton()
    }
}
