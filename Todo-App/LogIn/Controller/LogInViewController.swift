//
//  LogInViewController.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/13/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {
    
    
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
        txtEmail.becomeFirstResponder()
        
        txtEmail.backgroundColor = UIColor(white: 74/255, alpha: 1)
        txtEmail.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        txtPassword.backgroundColor = UIColor(white: 74/255, alpha: 1)
        txtPassword.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        
        txtEmail.setLeftPaddingPoints(30)
        txtPassword.setLeftPaddingPoints(30)
        
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
    
    @IBAction func btl_LogIn(_ sender: Any) {
        
        handleLogin()
    }
    
    func handleLogin() {
        
        guard let email = txtEmail.text, let password = txtPassword.text else { return }
        
        if email.isEmpty {
            self.present(Alert.shareAlert.showAlert(title: "Lỗi Đăng Nhập", message: "Không được để trống Email", title_button: "Đồng ý"), animated: true)
            return
        } else if password.isEmpty {
            self.present(Alert.shareAlert.showAlert(title: "Lỗi Đăng Nhập", message: "Không được để trống Password", title_button: "Đồng ý"), animated: true)
            return
        }
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                SVProgressHUD.dismiss()
                self.present(Alert.shareAlert.showAlert(title: "Lỗi Đăng Nhập", message: "Kiểm tra lại email và mật khẩu", title_button: "Đồng ý"), animated: true)
                return
            }
            
            SVProgressHUD.dismiss()
            
            let storyboard = UIStoryboard(name: "ListsStoryboard", bundle: nil)
            
            let Lists = storyboard.instantiateViewController(withIdentifier: "LISTS") as! ListsViewController
            
            self.present(Lists, animated: true)
        }
        
    }
    
}
