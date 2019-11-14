//
//  LoginViewController.swift
//  LectionUIKitTest
//
//  Created by Konstantin Polin on 31/10/2019.
//  Copyright © 2019 Maksakovsky Nikita. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var nameText: UITextField!
    @IBOutlet private var surnameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         let safeAreaGuide = view.safeAreaLayoutGuide
         
         NSLayoutConstraint.activate([
         nameText.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
         surnameText.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
         surnameText.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
         surnameText.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 20),
         loginButton.topAnchor.constraint(equalTo: surnameText.bottomAnchor, constant: 20),
         loginButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor)
         ])*/
        
        configureViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func onLoginTapped(_ sender: Any) {
        
        guard let name = nameText.text, let surname = surnameText.text else {
            return
        }
        
        if name.isEmpty && surname.isEmpty {
           // return
        }
        
        if name == "" && surname == "" {
            performSegue(withIdentifier: "ShowList", sender: self)
            
        } else {
            let alertController = UIAlertController(title: "ERROR", message: "Wrong data", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "close", style: .destructive, handler: {_ in
                alertController.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        super.performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let imageVC = segue.destination as? ImageViewController {
            let name = nameText.text ?? ""
            let surname = surnameText.text ?? ""
            
            imageVC.name = name
            imageVC.surname = surname
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let value = notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardFrame = value.cgRectValue
        
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardFrame.size.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    private func configureViews() {
        nameText.delegate = self
        surnameText.delegate = self
        
        nameText.translatesAutoresizingMaskIntoConstraints = false
        surnameText.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureConstr() {
        
    }
}
