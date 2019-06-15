//
//  ViewController.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 23/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit
import IOSShared

///The ActivityFormViewController class
class ActivityFormViewController: UIViewController {

    //MARK: View controll
    
    ///The save button outlet
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    ///The name text field outlet
    @IBOutlet weak var nameTextField: UITextField!
    
    //MARK: Properties
    
    ///The activities items
    var activity: ActivityModel?
    
    ///The view did load event
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        nameTextField.delegate = self
        
        if let activity = self.activity {
            nameTextField.text = activity.name
        }
        
        validateForm()
    }
    
    //MARK: view actions
    ///The cancel action
    ///- parameter sender: The sender object
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        
        let isPresentingViewController = presentingViewController is UINavigationController
        
        if isPresentingViewController {
            dismiss(animated: true, completion: nil)
        } else if let navController = navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    //MARK: navigation
    
    ///The prepare action. Triggers before send request to another view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let btn = sender as? UIBarButtonItem, btn === saveButton {
            activity = ActivityModel(name: nameTextField.text ?? "")
        }
    }
}

///Extension for UITextFieldDelegate
extension ActivityFormViewController: UITextFieldDelegate {
    
    ///Validates the form
    fileprivate func validateForm () {
        let text = self.nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        self.saveButton.isEnabled = !text.isEmpty
        self.nameTextField.text = text
    }
    
    ///Removes default responder from text filed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    ///Sets save button on disable state when user types text to text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.saveButton.isEnabled = false
    }
    
    ///Validate if form is valid after user tuped text
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateForm()
        
        if let name = self.nameTextField.text {
            self.activity = ActivityModel(name: name)
        }
    }
}

