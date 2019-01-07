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
//    let scrollView : UIScrollView = {
//        let sv = UIScrollView()
//        sv.translatesAutoresizingMaskIntoConstraints = false
//        sv.alwaysBounceVertical = true
//        sv.backgroundColor = UIColor.clear
//        sv.bounces = false
//        sv.showsVerticalScrollIndicator = false
//        return sv
//    }()
//
    var activeField: UITextField?
    
    // MARK: - CLASS METHODS
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: Delegates in controller
        // Note: remember to include the delegations on the relevant viewWillAppear() method of the controller
        //       in the particular textfield whereby it is intended to resign the first responder.
        //       For instance:
        //                     self.SignInVC.usernameTxt.delegate = self
        //                     self.SignInVC.passwordTxt.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - FUNCTIONS
    func setupView() {
        self.activeField = UITextField()
        
        // Adding the tapping functionality
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        
        
        // Setting the constraints for the view
//        self.view.addSubview(scrollView)
//        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true

    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        print("Keyboard will show called")
//        guard let keyboardInfo = notification.userInfo else { return }
//        if let keyboardSize = (keyboardInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
//            let keyboardHeigh = keyboardSize.height + 10
//            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeigh, right: 0)
//            self.scrollView.contentInsets = contentInsets
//            var viewRect = self.view.frame
//            viewRect.size.height -= keyboardHeigh
//            guard let activeField = self.activeField else { return }
//            if(!viewRect.contains(activeField.frame.origin)) {
//                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y - keyboardHeigh)
//                self.scrollView.setContentOffset(scrollPoint, animated: true)
//            }
//        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        print("Keyboard will hide called")
//        let contentInsets = UIEdgeInsets.zero
//        self.scrollView.contentInset = contentInsets
    }
}

// MARK: - EXTENSIONS
extension ScrollableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.activeField = nil
        return true
    }
}
