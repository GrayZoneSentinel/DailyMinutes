//
//  MainVC.swift
//  DailyMinutes
//
//  Created by Ernesto on 31/12/2018.
//  Copyright © 2018 GrayZoneSentinel. All rights reserved.
//

import UIKit
import Firebase

enum DayEvaluation : String {
    case bad =  "Malo"
    case good = "Bueno"
    case normal = "Normal"
    case all = "Todas"
}

class MainVC: UIViewController {
    
    // MARK: - OUTLETS & ELEMENTS
        @IBOutlet private weak var evaluationSegmentCtr: UISegmentedControl!
        @IBOutlet private weak var minutesTableView: UITableView!
    
    // MARK: - VARIABLES
        // db variables
            private var minutes = [Minute]()
            private var minutesCollectionRef: CollectionReference!
            private var minutesListener: ListenerRegistration!
        // interface variables
            private var evaluationSegment = DayEvaluation.normal.rawValue
        // authentication variables
            private var handleAuth: AuthStateDidChangeListenerHandle?
    
    // MARK: - CLASS METHODS
        override func viewWillAppear(_ animated: Bool) {
            handleAuth = Auth.auth().addStateDidChangeListener({ (auth, user) in
                if user == nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let logInVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                    self.present(logInVC, animated: true, completion: nil)
                } else {
                    self.setMinutesListener()
                }
            })
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            // UI SETUP
                minutesTableView.estimatedRowHeight = 115
                minutesTableView.rowHeight = UITableView.automaticDimension
                minutesTableView.tableFooterView = UIView()
                minutesTableView.backgroundColor = UIColor.init(white: 1, alpha: 0)
            // DELEGATIONS
                minutesTableView.delegate = self
                minutesTableView.dataSource = self
            // DB REFERENCES
                minutesCollectionRef = Firestore.firestore().collection(MINUTES_COL_REF)
        }
        override func viewWillDisappear(_ animated: Bool) {
            // LISTENERS REMOVALS
            if minutesListener != nil {
                minutesListener.remove()
            }
        }
    
    // MARK: - FUNCTIONS
        func setMinutesListener() {
            if evaluationSegment == DayEvaluation.all.rawValue {
                minutesListener = minutesCollectionRef
                    .order(by: TIMESTAMP, descending: true)
                    .addSnapshotListener { (snapshot, error) in
                        if let error = error {
                            debugPrint("An error arose while fetching the documents: \(error)")
                        } else {
                            self.minutes.removeAll()
                            // Bring the class function declared in Minute.swift to retrieve the data
                            self.minutes = Minute.parseDate(snapshot: snapshot)
                            self.minutesTableView.reloadData()
                        }
                    }
            } else {
                minutesListener = minutesCollectionRef
                    .whereField(EVALUACION, isEqualTo: evaluationSegment)
                    .order(by: TIMESTAMP, descending: true)
                    .addSnapshotListener { (snapshot, error) in
                        if let error = error {
                            debugPrint("An error arose while fetching the documents: \(error)")
                        } else {
                            self.minutes.removeAll()
                            
                            // Bring the class function declared in Minute.swift to retrieve the data
                            self.minutes = Minute.parseDate(snapshot: snapshot)
                            
                            self.minutesTableView.reloadData()
                        }
                    }
            }
        }

    // MARK: - ACTIONS
        @IBAction func evaluationSegmentChanged(_ sender: Any) {
            switch evaluationSegmentCtr.selectedSegmentIndex {
                case 0: evaluationSegment = DayEvaluation.all.rawValue
                case 1: evaluationSegment = DayEvaluation.bad.rawValue
                case 2: evaluationSegment = DayEvaluation.normal.rawValue
                case 3: evaluationSegment = DayEvaluation.good.rawValue
                default: evaluationSegment = DayEvaluation.all.rawValue
            }
            minutesListener.remove()
            setMinutesListener()
        }
        @IBAction func logoutBtnTapped(_ sender: Any) {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let error as NSError {
                    debugPrint("An error occurred while loging out: \(error.localizedDescription)")
            }
        }
}

// MARK: - TABLE VIEW EXTENSION
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return minutes.count
    }
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "minuteCell", for: indexPath) as? MinuteCell {
            // Include the delegate parameter in the configureCell function
            cell.configureCell(minute: minutes[indexPath.row], delegate: self)
            return cell
        } else { return UITableViewCell() }
    }
    // Selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueIdentifier = "toCommentsVC"
        performSegue(withIdentifier: segueIdentifier, sender: minutes[indexPath.row])
    }
    // Prepare for segue triggered within the selected row
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = "toCommentsVC"
        if segue.identifier == segueIdentifier {
            if let destinationVC = segue.destination as? CommentsVC {
                // Point to the Minute that we're trying to pass to the variable declared in the destVC as minute
                if let minute = sender as? Minute {
                    destinationVC.minute = minute
                }
            }
        }
    }
}
// MARK: - MINUTE DELEGATE EXTENSION
extension MainVC: MinuteDelegate {
    func minuteActionsTapped(minute: Minute) {
        // Here is where we create the alert to handle the deletion or the editing action
        // Testing -> print(minute.username)
        
    }
}
