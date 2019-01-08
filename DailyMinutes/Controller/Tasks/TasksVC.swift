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
    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    // MARK: - VARIABLES
    
        // var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
        // convert the hardcoded itemArray into an array of Items objects created in the Model
        var itemArray = [Item]()
    
        // User defaults -- Singleton
        let defaults = UserDefaults.standard
    
    // MARK: - CLASS METHODS
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the itemArray
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        // Deploy user defaults
        if let items = defaults.array(forKey: "TasksListArray") as? [Item] {
            itemArray = items
        }

    }

    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Check the refreshing of the tableView once the relevant cell is checked or unchecked
                // print("cellForRowAtIndexPath Called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        // Include the accessory type
            // Refactor with a ternary operator
            // if item.done == true {
            //  cell.accessoryType = .checkmark
            // } else {
            //  cell.accessoryType = .none
            // }
            cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // let item = itemArray[indexPath.row]
            // print(item)
        // Adapt the code to the new itemArray of Item objects
            // Refactor the code below in one single line
            let item = itemArray[indexPath.row]
                // if item.done == false {
                // item.done = true
                // } else {
                // item.done = false
                // }
            item.done = !item.done
        tableView.reloadData()
            //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            //        } else {
            //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            //        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - FUNCTIONS
    
    // MARK: - ACTIONS
    // MARK: Add new task
    @IBAction func addBtn(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Task", message: "", preferredStyle: .alert)
        let addingAction = UIAlertAction(title: "Add your task", style: .default) { (addAlert) in
            let newItem = Item()
            guard let text = textField.text else { return }
            newItem.title = text
            //print(text)
            self.itemArray.append(newItem)
            // User defaults
            self.defaults.set(self.itemArray, forKey: "TasksListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField(configurationHandler: { (alertTextfield) in
            alertTextfield.placeholder = "Create your new task"
            textField = alertTextfield
            //guard let text = textField.text else { return }
            //print(text)
            //print("Now")
        })
        
        alert.addAction(addingAction)
        present(alert, animated: true, completion: nil)
    }
    
}
