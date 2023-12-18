//
//  ViewController.swift
//  PasswordGalery
//
//  Created by Кирилл Курочкин on 07.12.2023.
//

import UIKit
import CoreGraphics
import SwiftyKeychainKit
class ViewController: UIViewController {
    
    @IBOutlet weak var singInLabel: UILabel!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var enterPassword: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    
    let viewmodel = CreatePassViewControllerModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
        registerForKeyboardNotifications()

    }
    @IBAction func EnterPasswordButtonPressed(_ sender: UIButton) {
        
    //    let userName = userName.text
      //  let password = passwordUser.text
    //    viewmodel.validateUser(username: String, password: String)
     //   navigateToViewController(withIdentifier: "SecondViewController")
        
        if let username = userName.text, let password = passwordUser.text,
            viewmodel.validateUser(username: username, password: password) {
            // Navigate to the next view controller
            
            navigateToViewController(withIdentifier: "SecondViewController")
            
        }

    }
    
    @IBAction func CreateAccountButtonPressed(_ sender: UIButton) {
        
        guard let controller = self.storyboard?.instantiateViewController(identifier: "CreatePassViewController") as? CreatePassViewController else {return}
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    private func navigateToViewController(withIdentifier identifier: String) {
        guard let controller = self.storyboard?.instantiateViewController(identifier: identifier) else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
   private func bind() {
        
        viewmodel.username.bind { text in
            self.userName.text = text
            print(text)}
        
        viewmodel.userpass.bind { text in
            self.passwordUser.text = text
            print(text)
            
        }
        
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstrain.constant = 0
        }else {
            bottomConstrain.constant = keyboardScreenEndFrame.height + 10
        //    scrolView.contentOffset = CGPoint(x: 0, y: scrolView.contentSize.height - keyboardScreenEndFrame.height)

        }
        
        view.needsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstrain.constant = 0
        }else {
            bottomConstrain.constant = keyboardScreenEndFrame.height + 10
       //     scrolView.contentOffset = CGPoint(x: 0, y: scrolView.contentSize.height - keyboardScreenEndFrame.height)

        }
        
        view.needsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
        
    }
}
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
