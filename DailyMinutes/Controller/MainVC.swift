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
                /* Testing:
                            guard let minuteUser = minute.username else { return }
                            print(minuteUser)
                */
        // Declare the Alert View Controller for the actions regarding the relevant Minute
        let alert = UIAlertController(title: "Delete minute", message: "Are you sure that you want to delete the minute and it's relevant comments?", preferredStyle: .actionSheet)
        // Declare the actions of the Alert Controller
        let deleteAlert = UIAlertAction(title: "Delete", style: .destructive) { (deleteAction) in
            
            self.delete(collection: Firestore.firestore().collection(MINUTES_COL_REF).document(minute.documentId).collection(COMMENTS_COL_REF), completion: { (error) in
                if let error = error {
                    debugPrint("An error occurred while deleting the comments comprised within the minute which is tend to delete: \(error.localizedDescription)")
                } else {
                    Firestore.firestore().collection(MINUTES_COL_REF).document(minute.documentId).delete(completion: { (error) in
                        if let error = error {
                            debugPrint("An error occurred while deleting the minute: \(error.localizedDescription)")
                        } else {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            })
        }
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Append the actions to the Alert Controller
        alert.addAction(deleteAlert)
        alert.addAction(cancelAlert)
        // Present the Alert Controller
        present(alert, animated: true, completion: nil)
    }
    // DELEGATE EXTENSION FUNCTIONS
    // Function to delete the minute and it's corresponding comments to avoid the persistence of the comments once the minute is erased
    func delete(collection: CollectionReference, batchSize: Int = 100, completion: @escaping(Error?) -> ()) {
        collection.limit(to: batchSize).getDocuments { (docset, error) in
            guard let docset = docset else {
                completion(error)
                return
            }
            guard docset.count > 0 else {
                completion(nil)
                return
            }
            let batch = collection.firestore.batch()
            docset.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { (batchError) in
                if let batchError = batchError {
                    completion( batchError )
                } else {
                    self.delete(collection: collection, batchSize: batchSize, completion: completion)
                }
            }
        }
    }
}
