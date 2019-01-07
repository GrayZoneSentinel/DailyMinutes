//
//  TasksVC.swift
//  DailyMinutes
//
//  Created by Ernesto on 07/01/2019.
//  Copyright © 2019 GrayZoneSentinel. All rights reserved.
//

import UIKit

class TasksVC: UITableViewController {

    // MARK: - OUTLETS
    
    // MARK: - VARIABLES
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    // MARK: - CLASS METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let item = itemArray[indexPath.row]
        // print(item)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK: - FUNCTIONS
    
    // MARK: - ACTIONS
    
}
