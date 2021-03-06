//
//  CreateUserVC.swift
//  DailyMinutes
//
//  Created by Ernesto on 02/01/2019.
//  Copyright © 2019 GrayZoneSentinel. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CreateUserVC: ScrollableViewController {

    // MARK : - OUTLETS
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var enterBtn: UIButton!
    
    // MARK : - VARIABLES
    
    // MARK : - METHODS
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.usernameTxt.delegate = self
        self.emailTxt.delegate = self
        self.passwordTxt.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // SVProgressHUD setup
            SVProgressHUD.setBackgroundColor(UIColor.init(white: 0, alpha: 0))
            SVProgressHUD.setForegroundColor(UIColor.orange)
            SVProgressHUD.setBackgroundLayerColor(UIColor.init(white: 1, alpha: 0.4))
    }
    
    
    // MARK : - ACTIONS
    @IBAction func enterBtnTapped(_ sender: Any) {
        guard let username = usernameTxt.text else { return }
        guard let email = emailTxt.text else { return }
        guard let password = passwordTxt.text else { return }
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: email, password: password) { (currentUser, error) in
            if let error = error {
                debugPrint("An error occurred while creating a new use: \(error.localizedDescription)")
            }
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    debugPrint("Error in displaying username: \(error.localizedDescription)")
                }
            })
            
            guard let userId = Auth.auth().currentUser?.uid else { return }
            Firestore.firestore().collection(USERS_REF).document(userId).setData([
                USERNAME : username,
                DATE_CREATED : FieldValue.serverTimestamp()
                ], completion: { (error) in
                    if let error = error {
                        debugPrint("An error occurred while creating the new user: \(error.localizedDescription) ")
                    } else {
                        SVProgressHUD.dismiss()
                        self.dismiss(animated: true, completion: nil)
                    }
            })
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
