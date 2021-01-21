//
//  AlarmsListTableViewController.swift
//  AlarmCoreData
//
//  Created by Karl Pfister on 1/19/21.
//

import UIKit

class AlarmsListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.sharedInstance.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? AlarmTableViewCell else {return UITableViewCell()}
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        cell.delegate = self
        cell.updateViews(with: alarm)

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        //identifier: what segue was triggered?
        if segue.identifier == "toViewAlarm" {
            //index: what cell triggered the segue?
            //destination: where am I trying to go?
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? AlarmDetailTableViewController else { return }
            //object to send: What am I trying to pass?
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            //object to receive it: who's going to "catch this object?
            destinationVC.alarm = alarm
        }
    }


}

extension AlarmsListTableViewController: AlarmTableViewCellDelegate {

    // Conform to AlarmCell Delegate
    func alarmWasToggled(sender: AlarmTableViewCell) {
        // Get the indexPath of the the sender; I.E. the cell
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        // Use that index to get the Alarm we need
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        // Use our Model Controller to handle the isEnabled Property
        AlarmController.sharedInstance.toggleIsEnabledFor(alarm: alarm)
        // Have the cell Update
        sender.updateViews(with: alarm)
    }
}
