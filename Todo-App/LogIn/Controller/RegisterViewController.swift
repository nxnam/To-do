//
//  RegisterViewController.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/19/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextField()
        setupBackground()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func setupTextField() {
        txtName.becomeFirstResponder()
        
        txtName.backgroundColor = UIColor(white: 74/255, alpha: 1)
        txtName.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        txtEmail.backgroundColor = UIColor(white: 74/255, alpha: 1)
        txtEmail.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        txtPassword.backgroundColor = UIColor(white: 74/255, alpha: 1)
        txtPassword.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        
        txtName.setLeftPaddingPoints(30)
        txtEmail.setLeftPaddingPoints(30)
        txtPassword.setLeftPaddingPoints(30)
        
        txtName.attributedPlaceholder = NSAttributedString(string: "Name",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btn_Register(_ sender: Any) {
        handleRegister()
    }
    
    func handleRegister() {
        SVProgressHUD.show()
        
        guard let name = txtName.text , let email = txtEmail.text, let password = txtPassword.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    sleep(1)
                }
                SVProgressHUD.dismiss()
                //print("Error", error ?? "")
                return
            }

            let ref = Database.database().reference(fromURL: SingLogInData.urlDatabase).child("users").child(uid)
            let value = ["name": name, "email": email, "password": password]

            ref.updateChildValues(value, withCompletionBlock: { (err, ref) in
                if err != nil {
                    SVProgressHUD.dismiss()
                    //print("Error", err ?? "")
                    return
                }
                SVProgressHUD.dismiss()
                //print("Success", name)
                self.dismiss(animated: true, completion: nil)
            
            })
        }
    }
    
}
