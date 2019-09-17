//
//  ViewController.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/13/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delayInSeconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            self.logIn()
        }
        
        setupBackground()
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
        
        self.present(LogIn, animated: true)
    }


}

