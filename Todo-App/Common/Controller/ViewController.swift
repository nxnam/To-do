//
//  ViewController.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/13/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delayInSeconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            self.logIn()
        }
        
//        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
//        AnalyticsParameterItemID: "my_item_id"
//        ])
        
        setupBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func logIn() {
        let storyboard = UIStoryboard(name: "LogInStoryboard", bundle: nil)
        
        let LogIn = storyboard.instantiateViewController(withIdentifier: "LOGIN") as! LogInViewController
        
        self.navigationController?.pushViewController(LogIn, animated: true)
    }


}

