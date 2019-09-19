//
//  Alert.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/14/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit
import Foundation

class Alert {
    
    static let shareAlert = Alert()
    
    var txtLists = ""
    
    func showAlert(title: String, message: String, title_button: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let btn_Action = UIAlertAction(title: title_button, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(btn_Action)
        
        return alert
    }
    
    func showAlertTextField(title: String, message: String, title_button: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        //let btn_Action = UIAlertAction(title: title_button, style: UIAlertAction.Style.default, handler: nil)
        let btn_Action = UIAlertAction(title: title_button, style: UIAlertAction.Style.default) { (btn_Action) in
            self.txtLists = alert.textFields?[0].text ?? ""
        }
        alert.addTextField { (txtList) in
        }
        alert.addAction(btn_Action)
        
        return alert
    }
}
