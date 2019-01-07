//
//  SignInVC.swift
//  DailyMinutes
//
//  Created by Ernesto on 02/01/2019.
//  Copyright © 2019 GrayZoneSentinel. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignInVC: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var getAccountBtn: UIButton!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    
    
    // VARIABLES
    
    
    
    // MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // SVProgressHUD setup
            SVProgressHUD.setBackgroundColor(UIColor.init(white: 0, alpha: 0))
            SVProgressHUD.setForegroundColor(UIColor.orange)
            SVProgressHUD.setBackgroundLayerColor(UIColor.init(white: 1, alpha: 0.4))
        
    }
    

    // MARK: - ACTIONS
    @IBAction func enterBtnTapped(_ sender: Any) {
        
        // Spinner show
        SVProgressHUD.show()
        
        guard let userEmail = usernameTxt.text else { return }
        guard let userPassword = passwordTxt.text else { return }
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (user, error) in
            if let error = error {
                debugPrint("An error occurred while login: \(error.localizedDescription)")
            } else {
                
                // Spinner dissmisal
                SVProgressHUD.dismiss()
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        // TODO: - Recover password
        print("Recover password button tapped!")
    }
}
