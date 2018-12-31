//
//  NewMinuteVC.swift
//  DailyMinutes
//
//  Created by Ernesto on 31/12/2018.
//  Copyright © 2018 GrayZoneSentinel. All rights reserved.
//

import UIKit
import Firebase

class NewMinuteVC: UIViewController, UITextViewDelegate {

    // OUTLETS & ELEMENTS
    @IBOutlet private weak var usernameLbl: UILabel!
    @IBOutlet private weak var minuteTxt: UITextView!
    @IBOutlet private weak var saveBtn: UIButton!
    @IBOutlet private weak var valoracionSegmentCtr: UISegmentedControl!
    
    // VARIABLES
    private var selectedValoracion = DayEvaluation.normal.rawValue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minuteTxt.layer.cornerRadius = 4
        saveBtn.layer.cornerRadius = 4
        minuteTxt.text = "Un breve comentario sobre tu día..."
        minuteTxt.textColor = UIColor.lightGray
        minuteTxt.delegate = self
        
    }
    
    // DELEGATIONS
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.white
    }
    
    
    // ACTIONS
    @IBAction func valoracionCtrChanged(_ sender: Any) {
        switch valoracionSegmentCtr.selectedSegmentIndex {
        case 0:
            selectedValoracion = DayEvaluation.bad.rawValue
        case 1:
            selectedValoracion = DayEvaluation.normal.rawValue
        case 2:
            selectedValoracion = DayEvaluation.good.rawValue
        default:
            selectedValoracion = DayEvaluation.normal.rawValue
            
        }
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        guard let username = usernameLbl.text else { return }
        Firestore.firestore().collection(MINUTES_COL_REF).addDocument(data: [
            USERNAME : username,
            TIMESTAMP : FieldValue.serverTimestamp(),
            EVALUACION : selectedValoracion,
            COMENTARIO : minuteTxt.text,
            NUM_LIKES : 0,
            NUM_COMMENTS : 0
        ]) { (error) in
            if let error = error {
                debugPrint("An error arose while adding the Minute: \(error)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
}
