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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        setMinutesListener()
        
        /* Dismissed:
         minutesCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                debugPrint("An error arose while fetching the documents: \(error)")
            } else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let data = document.data()
                    let username = data[USERNAME] as? String ?? "Anónimo"
                    let timestamp = data[TIMESTAMP] as? Date ?? Date()
                    let minute = data[COMENTARIO] as? String ?? "No hay comentarios"
                    let numComments = data[NUM_COMMENTS] as? Int ?? 0
                    let numLikes = data[NUM_LIKES] as? Int ?? 0
                    let documentId = document.documentID
                    let newMinute = Minute(username: username, timestamp: timestamp, minuteText: minute, numComments: numComments, numLikes: numLikes, documentId: documentId)
                    self.minutes.append(newMinute)
                }
                self.minutesTableView.reloadData()
            }
        }*/
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI SETUP
        minutesTableView.estimatedRowHeight = 115
        minutesTableView.rowHeight = UITableView.automaticDimension
        minutesTableView.tableFooterView = UIView()
        // DELEGATIONS
        minutesTableView.delegate = self
        minutesTableView.dataSource = self
        // DB REFERENCES
        minutesCollectionRef = Firestore.firestore().collection(MINUTES_COL_REF)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // LISTENERS REMOVALS
        minutesListener.remove()
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
                        guard let snap = snapshot else { return }
                        for document in snap.documents {
                            let data = document.data()
                            let username = data[USERNAME] as? String ?? "Anónimo"
                            let timestamp = data[TIMESTAMP] as? Date ?? Date()
                            let minute = data[COMENTARIO] as? String ?? "No hay comentarios"
                            let numComments = data[NUM_COMMENTS] as? Int ?? 0
                            let numLikes = data[NUM_LIKES] as? Int ?? 0
                            let documentId = document.documentID
                            
                            let newMinute = Minute(username: username, timestamp: timestamp, minuteText: minute, numComments: numComments, numLikes: numLikes, documentId: documentId)
                            
                            self.minutes.append(newMinute)
                            
                        }
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
                        guard let snap = snapshot else { return }
                        for document in snap.documents {
                            let data = document.data()
                            let username = data[USERNAME] as? String ?? "Anónimo"
                            let timestamp = data[TIMESTAMP] as? Date ?? Date()
                            let minute = data[COMENTARIO] as? String ?? "No hay comentarios"
                            let numComments = data[NUM_COMMENTS] as? Int ?? 0
                            let numLikes = data[NUM_LIKES] as? Int ?? 0
                            let documentId = document.documentID
                            
                            let newMinute = Minute(username: username, timestamp: timestamp, minuteText: minute, numComments: numComments, numLikes: numLikes, documentId: documentId)
                            
                            self.minutes.append(newMinute)
                            
                        }
                        self.minutesTableView.reloadData()
                    }
                }
        }
    }

    
    // MARK: - ACTIONS
    @IBAction func evaluationSegmentChanged(_ sender: Any) {
        switch evaluationSegmentCtr.selectedSegmentIndex {
        case 0:
            evaluationSegment = DayEvaluation.all.rawValue
        case 1:
            evaluationSegment = DayEvaluation.bad.rawValue
        case 2:
            evaluationSegment = DayEvaluation.normal.rawValue
        case 3:
            evaluationSegment = DayEvaluation.good.rawValue
        default:
            evaluationSegment = DayEvaluation.all.rawValue
            
        }
        
        
        minutesListener.remove()
        setMinutesListener()
    }
}


// MARK: - EXTENSIONS
extension MainVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return minutes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "minuteCell", for: indexPath) as? MinuteCell {
            
            cell.configureCell(minute: minutes[indexPath.row])
            
            return cell
            
        } else {
            
            return UITableViewCell()
        
        }
        
    }


}
