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
            // let defaults = UserDefaults.standard
            // Create our own user plist (instead of using User Defaults. Among other things because it is not working due to
            // the Firebase previous configuration for the Minutes section :: CODE REFERENCE -- AA1
        // Data file path to the plist whereby the user defaults are stored
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // MARK: - CLASS METHODS
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the itemArray
        // CODE REFERENCE -- AA1
            //        let newItem = Item()
            //        newItem.title = "Find Mike"
            //        itemArray.append(newItem)
            //        let newItem2 = Item()
            //        newItem2.title = "Buy Eggos"
            //        itemArray.append(newItem2)
            //        let newItem3 = Item()
            //        newItem3.title = "Destroy Demogorgon"
            //        itemArray.append(newItem3)
        
        // Data file path to the plist whereby the user defaults are stored
        // guard let path = dataFilePath else { return }
        // print(path)
        
        // Deploy user defaults
        // CODE REFERENCE -- AA1
                // if let items = defaults.array(forKey: "TasksListArray") as? [Item] {
                //    itemArray = items
                // }
          // Note: the code above is moved to a new function called loadItems()
          loadItems()

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
        
            //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            //        } else {
            //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            //        }
        // CODE REFERENCE -- AA1
        // tableView.reloadData()
           saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }

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
            // CODE REFERENCE -- AA1
                // self.defaults.set(self.itemArray, forKey: "TasksListArray")
                // let encoder = PropertyListEncoder()
                // do {
                //     let data = try encoder.encode(self.itemArray)
                //     try data.write(to: self.dataFilePath!)
                // } catch {
                //     debugPrint("An error occurs while encoding the Property List of ItemArray: \(error.localizedDescription)")
                // }
            //self.tableView.reloadData()
            self.saveItems()
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
    
    // MARK: - FUNCTIONS
    // MARK: Model manipulation methods
    func saveItems() {
        // CODE REFERENCE -- AA1
           // Cut from and new task action
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            debugPrint("An error occurs while encoding the Property List of ItemArray: \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    func loadItems() {
        // CODE REFERENCE -- AA1
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                debugPrint("An error occurs decoding the itemsArray in the property list: \(error.localizedDescription)")
            }
        }
    }
}
