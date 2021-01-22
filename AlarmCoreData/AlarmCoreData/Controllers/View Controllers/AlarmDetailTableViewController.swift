//
//  AlarmDetailTableViewController.swift
//  AlarmCoreData
//
//  Created by Devin Flora on 1/21/21.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var alarmFireDatePicker: UIDatePicker!
    @IBOutlet weak var alarmTitleTextField: UITextField!
    @IBOutlet weak var alarmIsEnabledButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Properties
    var alarm: Alarm?
    var isAlarmOn: Bool = true
    
    // MARK: - Actions
    @IBAction func alarmIsEnabledButtonTapped(_ sender: UIButton) {
        if let alarm = alarm {
            AlarmController.shared.toggleIsEnabled(alarm: alarm)
            isAlarmOn = alarm.isEnabled
        } else {
           
        }
        designIsEnabledButton()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = alarmTitleTextField.text, !title.isEmpty else { return }
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, title: title, fireDate: alarmFireDatePicker.date, isEnabled: isAlarmOn)
        } else {
            AlarmController.shared.createAlarmWith(title: title, fireDate: alarmFireDatePicker.date)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let alarm = alarm else { return }
        alarmTitleTextField.text = alarm.title
        alarmFireDatePicker.date = alarm.fireDate ?? Date()
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
    
}//End of Class

