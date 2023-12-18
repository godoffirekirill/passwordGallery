//
//  CreatePassViewController.swift
//  PasswordGalery
//
//  Created by Кирилл Курочкин on 07.12.2023.
//

import UIKit
import SwiftyKeychainKit
import CoreGraphics
class CreatePassViewController: UIViewController {

    @IBOutlet weak var scrolView: UIScrollView!
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    
    
    
    let viewmodel = CreatePassViewControllerModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bind()
    //    setupTextFields([loginTextField, passwordTextField, rePasswordTextField])
      //  loginTextField.delegate = self
     //   loginTextField.delegate = self
      //  passwordTextField.delegate = self
      //  setupTextFields([loginTextField],[passwordTextField],[rePasswordTextField])
        
        registerForKeyboardNotifications()
    }
    @IBAction func createButtonPressed(_ sender: UIButton) {
        viewmodel.login.value = loginTextField.text ?? ""
        viewmodel.password.value = passwordTextField.text ??  ""
        viewmodel.rePassword.value = rePasswordTextField.text ?? ""
        
        viewmodel.createButtonTapped()
        self.navigationController?.popViewController(animated: true)
    }
    

   
    func bind() {
        //   viewModel.login.bind{ text in}
        viewmodel.login.bind { text in
            self.loginTextField.text = text
            print(text)
            
        }
        viewmodel.password.bind { text in
            self.passwordTextField.text = text
            print(text)
        }
        viewmodel.rePassword.bind { text in
            self.rePasswordTextField.text = text
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
           // scrolView.contentOffset = CGPoint(x: 0, y: scrolView.contentSize.height - keyboardScreenEndFrame.height)

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
         //   scrolView.contentOffset = CGPoint(x: 0, y: scrolView.contentSize.height - keyboardScreenEndFrame.height)

        }
        
        view.needsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
}


extension CreatePassViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
