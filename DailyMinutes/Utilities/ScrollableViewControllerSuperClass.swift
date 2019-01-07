//
//  ScrollableViewControllerSuperClass.swift
//  DailyMinutes
//
//  Created by Ernesto on 07/01/2019.
//  Copyright © 2019 GrayZoneSentinel. All rights reserved.
//

import UIKit

class ScrollableViewController: UIViewController {
    
    // MARK: - VARIABLES
    let scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.backgroundColor = UIColor.clear
        sv.bounces = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    // MARK: - CLASS METHODS
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: Delegates in controller
        // Note: remember to include the delegations on the relevant viewWillAppear() method of the controller
        //       in the particular textfield whereby it is intended to resign the first responder.
        //       For instance:
        //                     self.SignInVC.usernameTxt.delegate = self
        //                     self.SignInVC.passwordTxt.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - FUNCTIONS
    func setupView() {
        // Adding the tapping functionality
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        // Setting the constraints for the view
        self.view.addSubview(scrollView)
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        
        
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

// MARK: - EXTENSIONS
extension ScrollableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
